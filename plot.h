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

    Q_INVOKABLE void Plot_Pt(int  step);
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
};

#endif // PLOT_H
