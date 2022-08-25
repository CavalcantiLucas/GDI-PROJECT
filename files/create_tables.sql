CREATE TABLE Pessoa {

    cpf VARCHAR2(11) NOT NULL,
    nome VARCHAR2(255) NOT NULL,
    genero VARCHAR2(1),
    idade NUMBER(2) NOT NULL,
    cep_f VARCHAR2(8) NOT NULL,
    complemento VARCHAR2(10),
    numero NUMBER(5),

    CONSTRAINT pessoa_pkey PRIMARY KEY (cpf),
    CONSTRAINT pessoa_gender CHECK (genero = 'M' OR genero = 'F'),
    CONSTRAINT pessoa_fkey FOREIGN KEY (cep_f) REFERENCES Endereco (cep)

}

CREATE TABLE Endereco {

    cep VARCHAR2(8) NOT NULL,
    rua VARCHAR2(100),
    
    CONSTRAINT endereco_pkey PRIMARY KEY (cep)
}

CREATE TABLE Jogador {

    cpf_p VARCHAR2(11) NOT NULL, 
    carteira NUMBER, -- definir tipo de carteira
    
    CONSTRAINT jogador_pkey PRIMARY KEY (cpf_p),
    CONSTRAINT jogador_fkey FOREIGN KEY (cpf_p) REFERENCES Pessoa (cpf)
}

CREATE TABLE Funcionario {

    cpf_p VARCHAR2(11) NOT NULL,
    cargo_f VARCHAR2(30) NOT NULL,
    cnpj_f VARCHAR2(14) NOT NULL,
    cpf_s VARCHAR2(11) NOT NULL,

    CONSTRAINT funcionario_pkey PRIMARY KEY (cpf_p),
    CONSTRAINT funcionario_fkey FOREIGN KEY (cpf_p) REFERENCES Pessoa (cpf),

    CONSTRAINT funcionario_fkey2 FOREIGN KEY (cpf_s) REFERENCES Funcionario (cpf_p),
    CONSTRAINT funcionario_fkey3 FOREIGN KEY (cnpj_f) REFERENCES Casa (cnpj),
    CONSTRAINT funcionario_fkey4 FOREIGN KEY (cargo) REFERENCES Emprego (cargo)
}

CREATE TABLE Emprego {

    cargo VARCHAR2(30) NOT NULL,
    salario NUMBER NOT NULL, -- definir salario base

    CONSTRAINT cargo_pkey PRIMARY KEY (cargo)
}

CREATE TABLE Casa {

    cnpj VARCHAR2(14) NOT NULL,
    nome VARCHAR2(255) NOT NULL,
    saldo NUMBER, -- definir modelo de saldo

    CONSTRAINT casa_pkey PRIMARY KEY (cnpj)
}

CREATE TABLE Jogo {

    nome VARCHAR2(255) NOT NULL,
    custo NUMBER,

    CONSTRAINT jogo_pkey PRIMARY KEY (nome)
}

CREATE TABLE Ficha_casa {

    cnpj_p VARCHAR2(14) NOT NULL,
    cor VARCHAR2(20) NOT NULL,
    valor NUMBER,

    CONSTRAINT fichacasa_pkey PRIMARY KEY (cnpj_p, cor),
    CONSTRAINT fichacasa_fkey FOREIGN KEY (cnpj_p) REFERENCES Casa (cnpj)
}

CREATE TABLE Joga {

    cpf_p VARCHAR2(11) NOT NULL,
    nomejogo_f VARCHAR2(255) NOT NULL,
    datahora TIMESTAMP NOT NULL,

    CONSTRAINT joga_pkey PRIMARY KEY (cpf_p, nomejogo_f, datahora),
    CONSTRAINT joga_fkey FOREIGN KEY (cpf_p) REFERENCES Jogador (cpf_p),
    CONSTRAINT joga_fkey2 FOREIGN KEY (nomejogo_f) REFERENCES Jogo (nome)
}

CREATE TABLE Organiza_joga {

    cpf_p VARCHAR2(11) NOT NULL,
    nomejogo_f VARCHAR2(255) NOT NULL,
    datahora_j TIMESTAMP NOT NULL,

    CONSTRAINT organizajoga_pkey PRIMARY KEY (cpf_p, nomejogo_f, datahora_j),

    CONSTRAINT organizajoga_fkey FOREIGN KEY (cpf_p) REFERENCES Jogador (cpf_p),
    CONSTRAINT organizajoga_fkey2 FOREIGN KEY (nomejogo_f) REFERENCES Jogo (nome),
    CONSTRAINT organizajoga_fkey3 FOREIGN KEY (datahora_j) REFERENCES Joga (datahora)
}

CREATE TABLE Funcionario_jogo_hora {

    nomejogo_f VARCHAR2(255) NOT NULL,
    datahora_j TIMESTAMP NOT NULL,
    cpf_p VARCHAR2(11) NOT NULL,

    CONSTRAINT funcjogohora_pkey PRIMARY KEY (nomejogo_f, datahora_j),
    CONSTRAINT funcjogohora_fkey FOREIGN KEY (nomejogo_f) REFERENCES Jogo (nome),
    CONSTRAINT funcjogohora_fkey2 FOREIGN KEY (datahora_j) REFERENCES Joga (datahora),
    CONSTRAINT funcjogohora_fkey3 FOREIGN KEY (cpf_p) REFERENCES Funcionario (cpf_p)
}

CREATE TABLE Contem {

    cnpj_p VARCHAR2(14) NOT NULL,
    nomejogo_f VARCHAR2(255) NOT NULL,

    CONSTRAINT contem_pkey PRIMARY KEY (cnpj_p, nomejogo_f),

    CONSTRAINT contem_fkey FOREIGN KEY (cnpj_p) REFERENCES Casa (cnpj),
    CONSTRAINT contem_fkey2 FOREIGN KEY (nomejogo_f) REFERENCES Jogo (nome)
}

CREATE TABLE Numero_telefone {

    cpf_p VARCHAR2(11) NOT NULL,
    telefone VARCHAR2(11) NOT NULL, -- modelo YY 9XXXX-XXXX

    CONSTRAINT telefone_pkey PRIMARY KEY (cpf_p, telefone),
    CONSTRAINT telefone_fkey FOREIGN KEY (cpf_p) REFERENCES Pessoa (cpf)
}

CREATE TABLE Compra {

    cpf_p VARCHAR2(11) NOT NULL,
    cpf_f VARCHAR2(11) NOT NULL,
    cor_f VARCHAR2(20) NOT NULL,
    cnpj_f VARCHAR2(14) NOT NULL,
    datahora TIMESTAMP NOT NULL,

    valor_compra NUMBER, -- definir tipo melhor

    CONSTRAINT compra_pkey PRIMARY KEY (cpf_p, cpf_f, cor_f, cnpj_f, datahora),
    CONSTRAINT compra_fkey FOREIGN KEY (cpf_p) REFERENCES Jogador (cpf_p),
    CONSTRAINT compra_fkey2 FOREIGN KEY (cpf_f) REFERENCES Funcionario (cpf_p),
    CONSTRAINT compra_fkey3 FOREIGN KEY (cor_f) REFERENCES Ficha_casa (cor),
    CONSTRAINT compra_fkey4 FOREIGN KEY (cnpj_f) REFERENCES Casa (cnpj)

}