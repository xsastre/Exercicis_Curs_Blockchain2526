// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GestioUsuaris
 * @dev Contracte de gestió d'usuaris amb control d'accés
 * @author Xavier Sastre - IB1105 Blockchain Course
 */
contract GestioUsuaris {
    
    // Estructura per a usuari
    struct Usuari {
        uint256 id;
        string nom;
        string email;
        uint256 edat;
        bool actiu;
        uint256 dataRegistre;
    }
    
    // Variables d'estat
    address public propietari;
    uint256 public totalUsuaris;
    uint256 public totalUsuarisActius;
    
    // Mappings
    mapping(uint256 => Usuari) public usuaris;
    mapping(address => uint256) public adrecaAId;
    mapping(address => bool) public administradors;
    
    // Events
    event UsuariRegistrat(uint256 indexed userId, address indexed adreca, string nom);
    event UsuariActualitzat(uint256 indexed userId, string nom, bool actiu);
    event UsuariEliminat(uint256 indexed userId);
    event AdministradorAfegit(address indexed admin);
    
    // Errors personalitzats
    error NoEsPropietari();
    error NoEsAdministrador();
    error UsuariNoExisteix();
    error JaRegistrat();
    error EdatInvalida();
    
    constructor() {
        propietari = msg.sender;
        administradors[msg.sender] = true;
    }
    
    // Modificadors
    modifier nomesPropietari() {
        if (msg.sender != propietari) revert NoEsPropietari();
        _;
    }
    
    modifier nomesAdministrador() {
        if (!administradors[msg.sender]) revert NoEsAdministrador();
        _;
    }
    
    modifier usuariExisteix(uint256 userId) {
        if (userId == 0 || userId > totalUsuaris) revert UsuariNoExisteix();
        _;
    }
    
    modifier contracteActiu() {
        if (totalUsuaris >= 1000) revert();
        _;
    }
    
    /**
     * @dev Registrar nou usuari
     * @param _nom Nom de l'usuari
     * @param _email Email de l'usuari
     * @param _edat Edat de l'usuari
     * @return ID del nou usuari
     */
    function registrarUsuari(
        string memory _nom,
        string memory _email,
        uint256 _edat
    ) 
        public 
        contracteActiu 
        returns (uint256)
    {
        if (bytes(_nom).length == 0) revert();
        if (bytes(_email).length == 0) revert();
        if (_edat < 18) revert EdatInvalida();
        if (adrecaAId[msg.sender] != 0) revert JaRegistrat();
        
        totalUsuaris++;
        uint256 nouId = totalUsuaris;
        
        usuaris[nouId] = Usuari({
            id: nouId,
            nom: _nom,
            email: _email,
            edat: _edat,
            actiu: true,
            dataRegistre: block.timestamp
        });
        
        adrecaAId[msg.sender] = nouId;
        totalUsuarisActius++;
        
        emit UsuariRegistrat(nouId, msg.sender, _nom);
        
        return nouId;
    }
    
    /**
     * @dev Obtenir les dades de l'usuari actual
     */
    function obtenirElMeuUsuari() 
        public 
        view 
        returns (
            uint256 id,
            string memory nom,
            string memory email,
            uint256 edat,
            bool actiu,
            uint256 dataRegistre
        )
    {
        uint256 userId = adrecaAId[msg.sender];
        if (userId == 0) revert UsuariNoExisteix();
        
        Usuari memory user = usuaris[userId];
        return (
            user.id,
            user.nom,
            user.email,
            user.edat,
            user.actiu,
            user.dataRegistre
        );
    }
    
    /**
     * @dev Actualitzar perfil d'usuari
     */
    function actualitzarPerfil(
        string memory _nom,
        string memory _email,
        uint256 _edat
    ) public {
        uint256 userId = adrecaAId[msg.sender];
        if (userId == 0) revert UsuariNoExisteix();
        
        if (bytes(_nom).length == 0) revert();
        if (bytes(_email).length == 0) revert();
        if (_edat < 18) revert EdatInvalida();
        
        Usuari storage user = usuaris[userId];
        user.nom = _nom;
        user.email = _email;
        user.edat = _edat;
        
        emit UsuariActualitzat(userId, _nom, user.actiu);
    }
    
    /**
     * @dev Desactivar compte
     */
    function desactivarCompte() public {
        uint256 userId = adrecaAId[msg.sender];
        if (userId == 0) revert UsuariNoExisteix();
        
        Usuari storage user = usuaris[userId];
        if (!user.actiu) revert();
        
        user.actiu = false;
        totalUsuarisActius--;
        
        emit UsuariActualitzat(userId, user.nom, false);
    }
    
    /**
     * @dev Afegir administrador (només propietari)
     */
    function afegirAdministrador(address nouAdmin)
        public
        nomesPropietari
    {
        if (nouAdmin == address(0)) revert();
        if (administradors[nouAdmin]) revert();
        
        administradors[nouAdmin] = true;
        emit AdministradorAfegit(nouAdmin);
    }
    
    /**
     * @dev Obtenir estadístiques
     */
    function obtenirEstadistiques()
        public
        view
        returns (
            uint256 total,
            uint256 actius,
            uint256 inactius
        )
    {
        return (
            totalUsuaris,
            totalUsuarisActius,
            totalUsuaris - totalUsuarisActius
        );
    }
}