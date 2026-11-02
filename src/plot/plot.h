#ifndef PLOT_H
#define PLOT_H

#include <QObject>
#include <QVariantList>
#include "convermatlabtoc.h"

class Plot : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QVariantList X READ GetX WRITE setX NOTIFY XChanged FINAL)
    Q_PROPERTY(QVariantList Y0 READ GetY0 WRITE setY0 NOTIFY Y0Changed FINAL)
    Q_PROPERTY(QVariantList Y1 READ GetY1 WRITE setY1 NOTIFY Y1Changed FINAL)
public:
    explicit Plot(QObject *parent = nullptr);
    enum NamePlot{
        pt,
        pv,
        tv,
        ph,
        th,
        proh,
        troh,
        ps,
        ts,
        pu,
        tu,
        pcv,
        tcv,
        pcp,
        tcp,
        pw,
        tw,
        pk,
        tk,

    };
    Q_ENUM(NamePlot)

    Q_INVOKABLE void drowPlot(NamePlot str, int  value);
signals:
    void XChanged ();
    void Y0Changed ();
    void Y1Changed ();


public slots:
    void setX(const QVariantList& list );
    void setY0(const QVariantList& list );
    void setY1(const QVariantList& list );
    QVariantList GetX() const;
    QVariantList GetY0() const;
    QVariantList GetY1() const;
private:
    Convermatlabtoc dia;
    QVariantList X , Y0 ,Y1;
    void Plot_Pt(int  step);

    void Plot_Pv(int  step);
    void Plot_Tv(int  step);
    void Plot_Ph(int  step);
    void Plot_Th(int  step);
    void Plot_Proh(int  step);
    void Plot_Troh(int  step);
    void Plot_Ps(int  step);
    void Plot_Ts(int  step);
    void Plot_Pu(int  step);
    void Plot_Tu(int  step);
    void Plot_Pcv(int  step);
    void Plot_Tcv(int  step);
    void Plot_Pcp(int  step);
    void Plot_Tcp(int  step);
    void Plot_Pw(int  step);
    void Plot_Tw(int  step);
    void Plot_Pk(int  step);
    void Plot_Tk(int  step);
};

#endif // PLOT_H
