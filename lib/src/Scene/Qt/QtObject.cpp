#include "QtObject.h"

#include <tuple>

#include <QObject>
#include <QVariant>
#include <QQmlContext>
#include <QtQml>

namespace spix
{

QtObject::QtObject(QObject* object, ItemPath path)
: m_object(object)
, m_path(path)
{
}

QtObject::StringsTuple QtObject::stringProperty(const std::string& name) const
{
    QQmlContext* const context = qmlContext(m_object);
    QVariant value;

    // Checks if the property is a context property
    // (context properties can overwrite properties so checking it first gives, intentionally, priority to context)
    if (context) {
        value = context->contextProperty(name.c_str());

        // If the QVariant property is valid (meaning property has be found) it doesn't check "classic" properties then (return anyway)
        if (value.isValid()){

            // Checks if the property can actually be converted to a string
            auto valueString = value.toString().toStdString();
            if (!valueString.empty()){
                return std::make_pair(valueString, "");
            }
            return std::make_pair("", "GetProperty: Property '" + name + "' in Object at path: " + m_path.string() + " can't be converted to string.");
        }
    }


    value = m_object->property(name.c_str());

    if (value.isValid()){

        // Checks if the property can actually be converted to a string
        auto valueString = value.toString().toStdString();
        if (!valueString.empty()){
            return std::make_pair(valueString, "");
        }
        return std::make_pair("", "GetProperty: Property '" + name + "' in Object at path: " + m_path.string() + " can't be converted to string.");
    }

    // No property QVariant property (context and classic) is valid, meaning the property doesn't exists for this Object
    return std::make_pair("", "GetProperty: Property not found: '" + name + "' in Object at path: " + m_path.string());
}

void QtObject::setStringProperty(const std::string& name, const std::string& value){
    m_object->setProperty(name.c_str(), value.c_str());
}

QObject* QtObject::qobject(){
    return m_object;
}

} // namespace spix
