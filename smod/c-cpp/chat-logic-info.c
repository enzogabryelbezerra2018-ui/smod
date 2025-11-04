// smod/c-cpp/chat-logic-info.c
// Parte do sistema de lógica do SMOD
// Comunicação simples tipo console + debug

#include <stdio.h>
#include <string.h>

void smod_console_message(const char* msg) {
    printf("[SMOD Console] %s\n", msg);
}

void smod_debug(const char* msg, const char* level) {
    printf("[DEBUG - %s]: %s\n", level, msg);
}

int main() {
    smod_console_message("Engine iniciada...");
    smod_debug("Carregando sistemas base", "INFO");

    // Simulação de comando do jogador
    char cmd[50];
    
    strcpy(cmd, "spawn_item");
    
    if(strcmp(cmd, "spawn_item") == 0) {
        smod_console_message("Objeto spawnado no mundo!");
        smod_debug("Item: cubo físico padrão", "EVENT");
    } else {
        smod_debug("Comando desconhecido", "WARN");
    }

    return 0;
}
