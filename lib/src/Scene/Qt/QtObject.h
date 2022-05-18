#pragma once

#include <Scene/Object.h>

class QObject;

namespace spix {

class QtObject : public Object {
public:
    QtObject() = delete;
    QtObject(QObject* object);

    std::string stringProperty(const std::string& name) const override;
    void setStringProperty(const std::string& name, const std::string& value) override;

    QObject* qobject();

private:
    QObject* m_object;
};

} // namespace spix