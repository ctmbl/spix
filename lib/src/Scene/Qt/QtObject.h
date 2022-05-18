#pragma once

#include <Scene/Object.h>
#include <Spix/Data/ItemPath.h>

class QObject;

namespace spix {

class QtObject : public Object {
public:
    using StringsTuple = std::pair<std::string,std::string>;

    QtObject() = delete;
    QtObject(QObject* object, ItemPath path);

    StringsTuple stringProperty(const std::string& name) const override;
    void setStringProperty(const std::string& name, const std::string& value) override;

    QObject* qobject();

private:
    QObject* m_object;
    ItemPath m_path;
};

} // namespace spix