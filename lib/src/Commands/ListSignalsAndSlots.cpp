#include "ListSignalsAndSlots.h"

#include <iostream>

#include <Scene/Scene.h>

#include <Scene/Qt/QtItem.h>

#include <QString>
#include <QList>
#include <QMetaMethod>
#include <QQuickItem>



namespace spix {
namespace cmd {

ListSignalsAndSlots::ListSignalsAndSlots(ItemPath path, std::promise<std::vector<std::string>> promise)
: m_path(std::move(path)),
m_promise(std::move(promise))
{
}

void ListSignalsAndSlots::execute(CommandEnvironment& env)
{
    auto quickitem = env.scene().itemAtPath(m_path);    //forced to instance the std::unique_ptr in the function scope ! 
    auto item = dynamic_cast<QtItem*>(quickitem.get()); //get the raw pointer from the std::unique_ptr

    std::vector<std::string> signalsList = {};

    if (!item) {
        env.state().reportError("ListSignalsAndSlots: [NOTFOUND] Item not found (or cast didn't work ?): " + m_path.string());
        std::cout << "[LISTSIGNAL][ERROR] Item not found (or cast didn't work ?): " << m_path.string() << "\n";
        m_promise.set_value(signalsList);
        return;
    }

    auto Qobj = item->qquickitem();

    if(Qobj == nullptr){
        env.state().reportError("ListSignalsAndSlots: [NOQUICKITEM] Unable to get QQuickItem from: " + m_path.string());
        std::cout << "[LISTSIGNAL][ERROR] Unable to get QQuickItem from: " << m_path.string() << "\n";
        m_promise.set_value(signalsList);
        return;
    }

    auto mo = Qobj->metaObject();

    QList<QString> slotSignatures; //to be modified, Qt include shouldn't appear here
    QList<QString> signalSignatures; //to be modified, Qt include shouldn't appear here

    // Start from MyClass members
    for(int methodIdx = mo->methodOffset(); methodIdx < mo->methodCount(); ++methodIdx) {
        QMetaMethod mm = mo->method(methodIdx);
        switch((int)mm.methodType()) {
            case QMetaMethod::Signal:
                signalSignatures.append(QString(mm.methodSignature())); // Requires Qt 5.0 or newer
                break;
            case QMetaMethod::Slot:
                slotSignatures.append(QString(mm.methodSignature())); // Requires Qt 5.0 or newer
                break;
        }
    }

    signalsList.reserve(slotSignatures.size()+signalSignatures.size()+2);
    signalsList.push_back("Slots:");
    std::transform(slotSignatures.begin(), slotSignatures.end(), std::back_inserter(signalsList), [](auto const& str)
    {
        return str.toStdString();
    });
    signalsList.push_back("Signals:");
    std::transform(signalSignatures.begin(), signalSignatures.end(), std::back_inserter(signalsList), [](auto const& str)
    {
        return str.toStdString();
    });

    // Just to visualize the contents of both lists
    std::cout << "Slots:" << "\n";
    foreach(QString signature, slotSignatures) std::cout << "\t" << signature.toStdString() << "\n";
    std::cout << "Signals:" << "\n";
    foreach(QString signature, signalSignatures) std::cout << "\t" << signature.toStdString() << "\n";

    m_promise.set_value(signalsList);

    }

} // namespace cmd
} // namespace spix
