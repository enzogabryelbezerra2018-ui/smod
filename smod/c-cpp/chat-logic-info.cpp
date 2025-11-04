// smod/c-cpp/chat-logic-info.cpp
// Lógica avançada SMOD em C++
// Ideia: mensagens internas, comandos, eventos e API futura

#include <iostream>
#include <string>
#include <map>

class SMODChatEngine {
private:
    std::map<std::string, std::string> eventRegistry;

public:
    SMODChatEngine() {
        std::cout << "[SMOD] Engine de chat iniciada.\n";
        registerEvent("spawn", "Spawn físico de objeto 3D");
        registerEvent("liquid_update", "Atualização de física líquida");
    }

    void registerEvent(std::string name, std::string desc) {
        eventRegistry[name] = desc;
    }

    void trigger(std::string eventName) {
        if(eventRegistry.count(eventName)) {
            std::cout << "[EVENT] " << eventName 
                      << " -> " << eventRegistry[eventName] << "\n";
        } else {
            std::cout << "[WARN] Evento não registrado: " << eventName << "\n";
        }
    }

    void sendMessage(std::string msg) {
        std::cout << "[SMOD] " << msg << "\n";
    }
};

int main() {
    SMODChatEngine engine;

    engine.sendMessage("Carregando mundo...");

    engine.trigger("spawn");
    engine.trigger("liquid_update");
    engine.trigger("evento_fake_teste"); // debug erro

    return 0;
}
