// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HolaBlockchain {
    
    // Variable d'estat per emmagatzemar el missatge
    string private missatge;
    
    // Constructor: s'executa al desplegar
    constructor() {
        missatge = "Hola Blockchain!";
    }
    
    // Funció per obtenir el missatge (lectura - gratis)
    function obtenirMissatge() public view returns (string memory) {
        return missatge;
    }
    
    // Funció per actualitzar el missatge (escriptura - paga gas)
    function actualitzarMissatge(string memory nouMissatge) public {
        missatge = nouMissatge;
    }
    
    // Funció per obtenir el propietari del contracte
    function obtenirPropietari() public view returns (address) {
        return msg.sender;
    }
}