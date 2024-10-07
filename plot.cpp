#include "plot.h"
#include <QDebug>
Plot::Plot(QObject *parent)
    : QObject{parent}
{}

void Plot::Plot_Pt(int step)
{
    QVariantList x ,y;
    for (double var = 0.01; var < 373.94599;) {
        x.append(var);
        y.append(dia.Xsteam("Psat_t",var,0));
        var += (373.94599/step);
    }
    setX(x);
    setY0(y);
}

QVariantList Plot::GetX() const
{
    return X;
}

QVariantList Plot::GetY0() const
{
    return Y0;
}

QVariantList Plot::GetY1() const
{
    return Y1;
}

void Plot::setX(const QVariantList &list)
{
    X =list;
    emit XChanged();
}

void Plot::setY0(const QVariantList &list)
{
    Y0 = list;
    emit  Y0Changed();
}

void Plot::setY1(const QVariantList &list)
{
    Y1= list;
    emit Y1Changed();
}
