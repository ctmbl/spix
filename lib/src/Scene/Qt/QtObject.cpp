#include "QtObject.h"

#include <QObject>
#include <QVariant>

namespace spix
{

QtObject::QtObject(QObject* object)
: m_object(object)
{
}

std::string QtObject::stringProperty(const std::string& name) const
{
    auto value = m_object->property(name.c_str());
    return value.toString().toStdString();
}

void QtObject::setStringProperty(const std::string& name, const std::string& value){
    m_object->setProperty(name.c_str(), value.c_str());
}

QObject* QtObject::qobject(){
    return m_object;
}

} // namespace spix
