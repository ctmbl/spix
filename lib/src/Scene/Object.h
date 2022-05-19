#pragma once

#include <string>

namespace spix {

/**
 * @brief Represents an object
 *
 * This object can be queried for properties and context properties of an object in the scene.
 * It will be implemented by the different backends, depending on whether this
 * is a Qml/Qt/Mock or other scene.
 */
class Object {
public:
    using StringPair = std::pair<std::string,std::string>;

    virtual ~Object() = default;

    // Object properties
    virtual StringPair stringProperty(const std::string& name) const = 0;
    virtual void setStringProperty(const std::string& name, const std::string& value) = 0;
};

} // namespace spix