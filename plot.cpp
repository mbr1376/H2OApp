#include "plot.h"
#include <QDebug>
Plot::Plot(QObject *parent)
    : QObject{parent}
{}

void Plot::drowPlot(NamePlot str, int value)
{
    X.clear();Y0.clear();Y1.clear();
    switch (str) {
    case pt:
        Plot_Pt(value);
        break;
    case pv:{

        Plot_Pv(value);
        break;
    }
    case tv:
        Plot_Tv(value);
        break;
    case ph:
        Plot_Ph(value);
        break;
    case th:
        Plot_Th(value);
        break;
     case proh:
        Plot_Proh(value);
        break;
    case troh:
        Plot_Troh(value);
        break;
    case ps:
        Plot_Ps(value);
        break;
    case ts:
        Plot_Ts(value);
        break;
    case pu:
        Plot_Pu(value);
        break;
    case tu:
        Plot_Tu(value);
        break;
    case pcv:
        Plot_Pcv(value);
        break;
    case tcv:
        Plot_Tcv(value);
        break;
    case pcp:
        Plot_Pcp(value);
        break;
    case tcp:
        Plot_Tcp(value);
        break;
    case pw:
        Plot_Pw(value);
        break;
    case tw:
        Plot_Tw(value);
        break;
    case pk:
        Plot_Pk(value);
        break;
    case tk:
        Plot_Tk(value);
        break;
    default:
        break;
    }
}

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

void Plot::Plot_Pv(int step)
{
    QVariantList  x, y0,y1;
    for (double var = 0.01; var < 374.946;) {
        x.append(dia.Xsteam("psat_t",var,0));
        y0.append(log(dia.Xsteam("vv_p",dia.Xsteam("psat_t",var,0),0)));
        y1.append(log(dia.Xsteam("vl_p",dia.Xsteam("psat_t",var,0),0)));
        var+=(374.94599 /step);
    }
    setX(x);
    setY0(y0);
    setY1(y1);
}

void Plot::Plot_Tv(int step)
{
    QVariantList  x, y0,y1;
    for (double i=0.01;i<373.94599 ;) {
        x.push_back(i);
        y0.push_back(log(dia.Xsteam("vl_t",(i),0)));
        y1.push_back(log(dia.Xsteam("vv_t",(i),0)));
        i=i+(373.94599 /step);
    }
    setX(x);
    setY0(y0);
    setY1(y1);
}

void Plot::Plot_Ph(int step)
{
    QVariantList  x, y0,y1;
    for (double i=0.01;i<=373.94599 ;) {
        x.push_back(dia.Xsteam("psat_t",(i),0));
        y1.push_back(dia.Xsteam("hv_p",dia.Xsteam("psat_t",(i),0),0));
        y0.push_back(dia.Xsteam("hl_p",dia.Xsteam("psat_t",(i),0),0));
        i=i+(373.94599 /step);

    }
    setX(x);
    setY0(y0);
    setY1(y1);
}

void Plot::Plot_Th(int step)
{
    QVariantList x ,y0,y1;
    for (double i=0.01;i<373.94599 ;) {
        x.push_back(i);
        y0.push_back(dia.Xsteam("hl_t",(i),0));
        y1.push_back(dia.Xsteam("hv_t",(i),0));
        i=i+(373.94599 /step);
    }
     setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Proh(int step)
{
    QVariantList x,y0,y1;
    for (double i=0.01;i<=373.94599 ;) {
        x.push_back(dia.Xsteam("psat_t",(i),0));
        y0.push_back(dia.Xsteam("rhol_p",dia.Xsteam("psat_t",(i),0),0));
        y1.push_back(dia.Xsteam("rhov_p",dia.Xsteam("psat_t",(i),0),0));
        i=i+(373.94599 /step);
    }
     setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Troh(int step)
{
    QVariantList x ,y0,y1;
    for (double i=0.01;i<373.94599 ;) {
        x.push_back(i);
        y0.push_back(dia.Xsteam("rhol_t",(i),0));
        y1.push_back(dia.Xsteam("rhov_t",(i),0));
        i=i+(373.94599 /step);
    }
     setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Ps(int step)
{
    QVariantList x,y0,y1;
    for (double i=0.01;i<=373.94599 ;) {
        x.push_back(dia.Xsteam("psat_t",(i),0));
        y0.push_back(dia.Xsteam("sl_p",dia.Xsteam("psat_t",(i),0),0));
        y1.push_back(dia.Xsteam("sv_p",dia.Xsteam("psat_t",(i),0),0));
        i=i+(373.94599 /step);
    }
     setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Ts(int step)
{
    QVariantList x,y1,y0;
    for (double i=0.01;i<373.94599 ;) {
        x.push_back(i);
        y0.push_back(dia.Xsteam("sl_t",(i),0));
        y1.push_back(dia.Xsteam("sv_t",(i),0));
        i=i+(373.94599 /step);
    }
     setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Pu(int step)
{
    QVariantList x ,y0,y1;
    for (double i=0.01;i<=373.94599 ;) {
        x.push_back(dia.Xsteam("psat_t",(i),0));
        y0.push_back(dia.Xsteam("ul_p",dia.Xsteam("psat_t",(i),0),0));
        y1.push_back(dia.Xsteam("uv_p",dia.Xsteam("psat_t",(i),0),0));
        i=i+(373.94599 /step);
    }
     setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Tu(int step)
{
    QVariantList x,y0,y1;
    for (double i=0.01;i<373.94599 ;) {
        x.push_back(i);
        y0.push_back(dia.Xsteam("ul_t",i,0));
        y1.push_back(dia.Xsteam("uv_t",(i),0));
        i=i+(373.94599 /step);
    }
     setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Pcv(int step)
{
    QVariantList x, y0, y1;
    for (double i=0.01;i<=373.94599 ;) {
        x.push_back(dia.Xsteam("psat_t",(i),0));
        y0.push_back(dia.Xsteam("cvl_p",dia.Xsteam("psat_t",(i),0),0));
        y1.push_back(dia.Xsteam("cvv_p",dia.Xsteam("psat_t",(i),0),0));

        i=i+(373.94599 /step);

    }
     setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Tcv(int step)
{
    QVariantList x,y0,y1;
    for (double i=0.01;i<373.94599 ;) {
        x.push_back(i);
        y0.push_back(dia.Xsteam("cvl_t",(i),0));
        y1.push_back(dia.Xsteam("cvv_t",(i),0));

        i=i+(373.94599 /step);

    }
    setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Pcp(int step)
{
    QVariantList x ,y0,y1;
    double delta=(373.94599-0.01)/(step-1);
    for (double i=0;i<step ;i++) {
        x.push_back(dia.Xsteam("psat_t",(0.01+i*delta),0));
        y0.push_back(dia.Xsteam("cpl_p",dia.Xsteam("psat_t",(0.01+i*delta),0),0));
        y1.push_back(dia.Xsteam("cpv_p",dia.Xsteam("psat_t",(0.01+i*delta),0),0));
        //i=i+(373.94599 /valu1);
    }
     setX(x);
    setY0(y0);
    setY1(y1);

}

void Plot::Plot_Tcp(int step)
{
    QVariantList x,y0,y1;
    double delta=(373.94599-0.01)/(step-1);
    //qDebug()<<QString::number(dia->Xsteam("cpl_t",371.602,0));
    for (double i=0;i<step ;i++) {
        x.push_back(0.01+i*delta);
        y0.push_back(dia.Xsteam("cpl_t",(0.01+i*delta),0));
        y1.push_back(dia.Xsteam("cpv_t",(0.01+i*delta),0));
        //i=i+(373.94599 /valu1);

    }
    setX(x);
    setY0(y0);
    setY1(y1);
}

void Plot::Plot_Pw(int step)
{
    QVariantList x , y0 , y1;
    double delta=(373.94599-0.01)/(step-1);
    for (double i=0;i<step ;i++) {
        x.push_back(dia.Xsteam("psat_t",(0.01+i*delta),0));
        y0.push_back(dia.Xsteam("wl_p",dia.Xsteam("psat_t",(0.01+i*delta),0),0));
        y1.push_back(dia.Xsteam("wv_p",dia.Xsteam("psat_t",(0.01+i*delta),0),0));
        //i=i+(373.94599 /valu1);
    }
    setX(x);
    setY0(y0);
    setY1(y1);
}

void Plot::Plot_Tw(int step)
{
    QVariantList x , y0 , y1;
    double delta=(373.94599-0.01)/(step-1);
    for (double i=0;i<step ;i++) {
        x.push_back(0.01+i*delta);
        y0.push_back(dia.Xsteam("wl_t",(0.01+i*delta),0));
        y1.push_back(dia.Xsteam("wv_t",(0.01+i*delta),0));

    }
    setX(x);
    setY0(y0);
    setY1(y1);
}

void Plot::Plot_Pk(int step)
{
    QVariantList x ,y0,y1;
    for (double i=0.01;i<=373.94599 ;) {
        x.push_back(dia.Xsteam("psat_t",(i),0));
        y0.push_back(dia.Xsteam("tcl_p",dia.Xsteam("psat_t",(i),0),0));
        y1.push_back(dia.Xsteam("tcv_p",dia.Xsteam("psat_t",(i),0),0));
        i=i+(373.94599 /step);
    }
    setX(x);
    setY0(y0);
    setY1(y1);
}

void Plot::Plot_Tk(int step)
{
    QVariantList x ,y0,y1;
    for (double i=0.01;i<373.94599 ;) {
        x.push_back(i);
        y0.push_back (dia.Xsteam("tcl_t",(i),0));
        y1.push_back( dia.Xsteam("tcv_t",(i),0));

        i=i+(373.94599 /step);

    }
    setX(x);
    setY0(y0);
    setY1(y1);
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
