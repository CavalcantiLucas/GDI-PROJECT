CREATE TABLE Pessoa {
    cpf VARCHAR2(11) NOT NULL,
    nome VARCHAR2(255) NOT NULL,
    genero VARCHAR2(1),
    idade NUMBER(2) NOT NULL,
    cep_p VARCHAR2(8),
    complemento VARCHAR2(10),
    numero NUMBER(5),

    CONSTRAINT pessoa_pkey PRIMARY KEY (cpf),
    CONSTRAINT pessoa_gender CHECK (genero = 'M' OR genero = 'F')
    CONSTRAINT pessoa_fkey FOREIGN KEY (cep_p) REFERENCES Endereco (cep)

}

CREATE TABLE Endereco {

    cep VARCHAR2(8) NOT NULL,
    rua VARCHAR2(100),
    
    CONSTRAINT endereco_pkey PRIMARY KEY (cep)
}

CREATE TABLE Jogador {

    cpf_j VARCHAR2(11) NOT NULL, 
    carteira NUMBER, -- Qual o tipo de carteira ?
    
    CONSTRAINT jogador_pkey PRIMARY KEY (cpf_j),
    CONSTRAINT jogador_fkey FOREIGN KEY (cpf_j) REFERENCES Pessoa (cpf)
}