#ifndef STEAMCALCULATOR_H
#define STEAMCALCULATOR_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

#include "convermatlabtoc.h"

class SteamCalculator : public QObject
{
    Q_OBJECT

public:
    explicit SteamCalculator(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap calculate(const QString &state, double temperatureC, double pressureBar);
    Q_INVOKABLE QVariantList saturationTable();
    Q_INVOKABLE QVariantList pvCurve();

private:
    Convermatlabtoc steam;
};

#endif // STEAMCALCULATOR_H
