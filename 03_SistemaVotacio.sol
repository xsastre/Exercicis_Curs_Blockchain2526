// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SistemaVotacio {

    // Struct per al candidat
    struct Candidat {
        uint256 id;
        string nom;
        uint256 vots;
        bool actiu;
    }

    // Variables d'estat
    address public propietari;
    uint256 public totalCandidats;
    uint256 public totalVots;
    bool public votacioIniciada;
    bool public votacioFinalitzada;

    // Mappings
    mapping(uint256 => Candidat) public candidats;  // ID -> Candidat
    mapping(address => bool) public haVotat;        // Address -> Bool
    mapping(address => uint256) public votRealitzat; // Address -> CandidatID

    // Array per iterar candidats
    uint256[] public llistaCandidatsIds;

    // Events
    event CandidatRegistrat(uint256 indexed id, string nom);
    event VotEmes(address indexed votant, uint256 indexed candidatId);
    event VotacioFinalitzada(uint256 guanyadorId);

    constructor() {
        propietari = msg.sender;
    }

    // Modificadors
    modifier nomesPropietari() {
        require(msg.sender == propietari, "No es propietari");
        _;
    }

    modifier votacioActiva() {
        require(votacioIniciada, "Votacio no iniciada");
        require(!votacioFinalitzada, "Votacio finalitzada");
        _;
    }

    // Afegir candidat (només propietari)
    function afegirCandidat(string memory nom) 
        public 
        nomesPropietari 
    {
        require(bytes(nom).length > 0, "Nom buit");
        require(!votacioIniciada, "No es poden afegir candidats durant la votacio");

        totalCandidats++;
        uint256 nouId = totalCandidats;

        candidats[nouId] = Candidat({
            id: nouId,
            nom: nom,
            vots: 0,
            actiu: true
        });

        llistaCandidatsIds.push(nouId);

        emit CandidatRegistrat(nouId, nom);
    }

    // Obtenir tots els candidats (per al frontend)
    function obtenirTotsCandidats() 
        public 
        view 
        returns (
            uint256[] memory ids,
            string[] memory noms,
            uint256[] memory vots,
            bool[] memory actius
        )
    {
        uint256 longitud = llistaCandidatsIds.length;
        ids = new uint256[](longitud);
        noms = new string[](longitud);
        vots = new uint256[](longitud);
        actius = new bool[](longitud);

        for (uint256 i = 0; i < longitud; i++) {
            uint256 id = llistaCandidatsIds[i];
            Candidat memory c = candidats[id];

            ids[i] = c.id;
            noms[i] = c.nom;
            vots[i] = c.vots;
            actius[i] = c.actiu;
        }

        return (ids, noms, vots, actius);
    }

    // Iniciar votació
    function iniciarVotacio() public nomesPropietari {
        require(!votacioIniciada, "Ja iniciada");
        require(totalCandidats >= 2, "Minim 2 candidats");

        votacioIniciada = true;
    }

    // Votar
    function votar(uint256 candidatId) public votacioActiva {
        require(!haVotat[msg.sender], "Ja has votat");
        require(candidatId > 0 && candidatId <= totalCandidats, "Candidat invalid");
        require(candidats[candidatId].actiu, "Candidat no actiu");

        // Registrar vot
        haVotat[msg.sender] = true;
        votRealitzat[msg.sender] = candidatId;
        candidats[candidatId].vots++;
        totalVots++;

        emit VotEmes(msg.sender, candidatId);
    }

    // Finalitzar votació
    function finalitzarVotacio() public nomesPropietari {
        require(votacioIniciada, "No iniciada");
        require(!votacioFinalitzada, "Ja finalitzada");

        votacioFinalitzada = true;

        // Trobar guanyador
        uint256 guanyadorId = 0;
        uint256 maxVots = 0;

        for (uint256 i = 0; i < llistaCandidatsIds.length; i++) {
            uint256 id = llistaCandidatsIds[i];
            if (candidats[id].vots > maxVots) {
                maxVots = candidats[id].vots;
                guanyadorId = id;
            }
        }

        emit VotacioFinalitzada(guanyadorId);
    }

    // Obtenir guanyador
    function obtenirGuanyador() 
        public 
        view 
        returns (uint256 id, string memory nom, uint256 vots)
    {
        require(votacioFinalitzada, "Votacio no finalitzada");

        uint256 guanyadorId = 0;
        uint256 maxVots = 0;

        for (uint256 i = 0; i < llistaCandidatsIds.length; i++) {
            uint256 id = llistaCandidatsIds[i];
            if (candidats[id].vots > maxVots) {
                maxVots = candidats[id].vots;
                guanyadorId = id;
            }
        }

        return (guanyadorId, candidats[guanyadorId].nom, candidats[guanyadorId].vots);
    }

    // Consultar el meu vot
    function obtenirElMeuVot() 
        public 
        view 
        returns (uint256 candidatId, bool votat)
    {
        return (votRealitzat[msg.sender], haVotat[msg.sender]);
    }

}