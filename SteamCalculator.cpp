#include "SteamCalculator.h"

#include <cmath>

namespace {
QVariantMap errorResult(const QString &message)
{
    return {{QStringLiteral("ok"), false}, {QStringLiteral("error"), message}};
}

bool validProperty(double value)
{
    return std::isfinite(value) && value >= 0.0 && value < 1.0e8;
}

QVariantMap makeRow(Convermatlabtoc &steam, double temperatureC)
{
    const double pressureBar = steam.Xsteam(QStringLiteral("psat_t"), temperatureC, 0);
    if (!std::isfinite(pressureBar) || pressureBar <= 0.0)
        return {};

    const double liquidEnthalpy = steam.Xsteam(QStringLiteral("hl_p"), pressureBar, 0);
    const double vaporEnthalpy = steam.Xsteam(QStringLiteral("hv_p"), pressureBar, 0);
    if (!validProperty(liquidEnthalpy) || !validProperty(vaporEnthalpy))
        return {};

    return {
        {QStringLiteral("temperature"), temperatureC},
        {QStringLiteral("pressure"), pressureBar},
        {QStringLiteral("liquidEnthalpy"), liquidEnthalpy},
        {QStringLiteral("vaporEnthalpy"), vaporEnthalpy}
    };
}
}

SteamCalculator::SteamCalculator(QObject *parent)
    : QObject(parent)
{
}

QVariantMap SteamCalculator::calculate(const QString &state, double temperatureC, double pressureBar)
{
    if (state != QStringLiteral("saturatedLiquid")
        && state != QStringLiteral("saturatedVapor")
        && state != QStringLiteral("compressed")
        && state != QStringLiteral("superheated")) {
        return errorResult(QStringLiteral("Choose a supported water/steam state."));
    }

    if (!std::isfinite(temperatureC) || !std::isfinite(pressureBar))
        return errorResult(QStringLiteral("Enter valid numeric temperature and pressure values."));

    const bool saturated = state == QStringLiteral("saturatedLiquid")
        || state == QStringLiteral("saturatedVapor");
    if (saturated) {
        if (temperatureC < 0.01 || temperatureC > 373.94599)
            return errorResult(QStringLiteral("Saturation temperature must be between 0.01 and 373.95 °C."));

        pressureBar = steam.Xsteam(QStringLiteral("psat_t"), temperatureC, 0);
        if (!std::isfinite(pressureBar) || pressureBar <= 0.0)
            return errorResult(QStringLiteral("Could not calculate saturation pressure for this temperature."));
    } else {
        if (pressureBar <= 0.00611657 || pressureBar > 1000.0)
            return errorResult(QStringLiteral("Pressure must be greater than 0.0061 bar and no more than 1000 bar."));
        if (temperatureC <= 0.0 || temperatureC > 2000.0)
            return errorResult(QStringLiteral("Temperature must be greater than 0 °C and no more than 2000 °C."));

        const double region = steam.region_pT(pressureBar / 10.0, temperatureC + 273.15);
        if (region == 0.0 || region == 4.0)
            return errorResult(QStringLiteral("These pressure and temperature values are outside a calculable single-phase state."));
        if (state == QStringLiteral("compressed") && region != 1.0)
            return errorResult(QStringLiteral("The selected state is not compressed liquid at these conditions."));
        if (state == QStringLiteral("superheated") && region != 2.0 && region != 3.0 && region != 5.0)
            return errorResult(QStringLiteral("The selected state is not superheated vapor at these conditions."));
    }

    const bool liquid = state == QStringLiteral("saturatedLiquid") || state == QStringLiteral("compressed");
    const QString suffix = liquid ? QStringLiteral("l") : QStringLiteral("v");
    const double p = pressureBar;
    const double t = temperatureC;
    const auto property = [this, saturated, &suffix, p, t](const QString &name) {
        if (saturated)
            return steam.Xsteam(name + suffix + QStringLiteral("_p"), p, 0);
        return steam.Xsteam(name + QStringLiteral("_pt"), p, t);
    };

    const double volume = property(QStringLiteral("v"));
    const double enthalpy = property(QStringLiteral("h"));
    const double entropy = property(QStringLiteral("s"));
    const double internalEnergy = property(QStringLiteral("u"));
    const double cp = property(QStringLiteral("cp"));
    const double cv = property(QStringLiteral("cv"));
    const double soundSpeed = property(QStringLiteral("w"));
    if (!validProperty(volume) || volume <= 0.0 || !validProperty(enthalpy)
        || !validProperty(entropy) || !validProperty(internalEnergy)
        || !validProperty(cp) || !validProperty(cv) || !validProperty(soundSpeed))
        return errorResult(QStringLiteral("The steam engine could not calculate all properties for this state."));

    return {
        {QStringLiteral("ok"), true},
        {QStringLiteral("state"), state},
        {QStringLiteral("temperature"), t},
        {QStringLiteral("pressure"), p},
        {QStringLiteral("enthalpy"), enthalpy},
        {QStringLiteral("entropy"), entropy},
        {QStringLiteral("volume"), volume},
        {QStringLiteral("density"), 1.0 / volume},
        {QStringLiteral("internalEnergy"), internalEnergy},
        {QStringLiteral("cp"), cp},
        {QStringLiteral("cv"), cv},
        {QStringLiteral("soundSpeed"), soundSpeed}
    };
}

QVariantList SteamCalculator::saturationTable()
{
    QVariantList rows;
    for (double temperature : {20.0, 50.0, 100.0}) {
        const QVariantMap row = makeRow(steam, temperature);
        if (row.isEmpty())
            return {};
        rows.append(row);
    }
    return rows;
}

QVariantList SteamCalculator::pvCurve()
{
    QVariantList points;
    constexpr int pointCount = 50;
    constexpr double minTemperature = 5.0;
    constexpr double maxTemperature = 360.0;
    for (int i = 0; i < pointCount; ++i) {
        const double temperature = minTemperature
            + (maxTemperature - minTemperature) * i / (pointCount - 1);
        const double pressure = steam.Xsteam(QStringLiteral("psat_t"), temperature, 0);
        if (!std::isfinite(pressure) || pressure <= 0.0)
            continue;
        const double liquidVolume = steam.Xsteam(QStringLiteral("vl_p"), pressure, 0);
        const double vaporVolume = steam.Xsteam(QStringLiteral("vv_p"), pressure, 0);
        if (validProperty(liquidVolume) && liquidVolume > 0.0
            && validProperty(vaporVolume) && vaporVolume > 0.0) {
            points.append(QVariantMap{
                {QStringLiteral("pressure"), pressure},
                {QStringLiteral("liquidVolume"), liquidVolume},
                {QStringLiteral("vaporVolume"), vaporVolume}
            });
        }
    }
    return points;
}
