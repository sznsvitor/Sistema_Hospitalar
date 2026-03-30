create database Hospital;

create type cobertura_plano as enum('regional', 'nacional');
create type status_leito as enum ('ocupado', 'livre', 'em manutencao');
create type turno_enfermeira as enum ('manha', 'tarde', 'noite');
create type tipo_atendimento as enum ('consulta', 'emergencia', 'revisao');
create type status_atendimento as enum ('realizado', 'cancelado', 'agendado');
create type classificacao_laboratorio as enum ('interno', 'externo');
create type status_fatura as enum ('pendente','pago','cancelado','em_analise');
create type forma_pagamento as enum ('pix','cartao','boleto','dinheiro');
create type tipo_fatura_item as enum ('atendimento', 'exame', 'internacao');

create table hospital (
    cnpj varchar(20) primary key unique not null,
    nome varchar(30) not null
);

create table plano_de_saude (
    nome_plano varchar(30) primary key unique not null,
    telefone varchar,
    cobertura cobertura_plano
);

create table credenciamento (
    id_credenciamento serial primary key,
    data date,
    cnpj varchar,
    nome_plano varchar(50),
    foreign key (cnpj) references hospital (cnpj),
    foreign key (nome_plano) references plano_de_saude (nome_plano)
);

create table leito (
    id_leito serial primary key,
    status status_leito
);

create table enfermeira (
    cre varchar(20) primary key unique not null,
    nome varchar(30) not null,
    turno turno_enfermeira,
    especialidade varchar(20),
    cre_chefia varchar,
    foreign key (cre_chefia) references enfermeira
);

create table ala (
    id_ala serial primary key,
    tipo varchar(20),
    leitos_disponiveis int not null,
    cnpj varchar,
    id_leito int,
    cre varchar,
    foreign key (cnpj) references hospital,
    foreign key (id_leito) references leito,
    foreign key (cre) references enfermeira
);

create table paciente (
    cpf varchar(20) primary key unique not null,
    nome varchar(30),
    idade smallint,
    telefone varchar,
    nome_plano varchar,
    foreign key (nome_plano) references plano_de_saude (nome_plano)
);

create table internacao (
	id_internacao serial primary key,
    data_entrada date,
    data_saida date,
    custo numeric,
    cpf varchar,
    id_leito int,
    foreign key (cpf) references paciente,
    foreign key (id_leito) references leito,
    constraint check_datas check (data_saida is null or data_saida >= data_entrada)
);

create table medico (
    crm varchar(20) primary key unique not null,
    nome varchar(30),
    telefone varchar,
    especialidade varchar(20)
);

create table atendimento (
    id_atendimento serial primary key,
    data date not null,
    hora time not null,
    status status_atendimento not null,
    tipo tipo_atendimento not null,
    observacao varchar,
    custo numeric,
    crm varchar,
    cpf varchar,
    foreign key (crm) references medico,
    foreign key (cpf) references paciente
);

create table exame (
    id_exame serial primary key,
    tipo varchar(50),
    custo numeric,
    descricao text,
    anexo bytea,
    cpf varchar,
    foreign key (cpf) references paciente
);

create table pedido (
	id_pedido serial primary key,
    data date not null,
    hora time not null,
    crm varchar,
    id_exame smallint,
    foreign key (crm) references medico,
    foreign key (id_exame) references exame
);

create table laboratorio (
    id_lab serial primary key,
    classificacao classificacao_laboratorio
);

create table laudo (
    id_laudo serial primary key,
    resultado text,
    id_exame smallint,
    id_lab smallint,
    foreign key (id_exame) references exame,
    foreign key (id_lab) references laboratorio
);

create table prescricao (
    id_prescricao serial primary key,
    data date not null,
    id_atendimento smallint,
    foreign key (id_atendimento) references atendimento
);

create table medicamento (
    id_medicamento serial primary key,
    nome varchar(50)
);

create table prescricao_medicamento (
 	id_pres_med serial primary key,
    dosagem varchar(50),
    quantidade_dias smallint,
    descricao text,
    id_prescricao smallint,
    id_medicamento smallint,
    foreign key (id_prescricao) references prescricao,
    foreign key (id_medicamento) references medicamento
);

create table fatura (
	id_fatura serial primary key, 
	data_emissao date,
	data_vencimento date,
	status status_fatura,
	forma_pagamento forma_pagamento,
	nome_plano varchar,
	id_atendimento int,
	foreign key (nome_plano) references plano_de_saude,
	foreign key (id_atendimento) references atendimento
);

create table fatura_item (
    id_item serial primary key,
    id_fatura int,
    tipo tipo_fatura_item,
    id_referencia int,
    foreign key (id_fatura) references fatura
);

create table pesquisa_satisfacao (
    id_pesquisa serial primary key,
    data date not null,
    nota smallint not null,
    comentario text,
    recomendaria boolean not null,
    tempo_espera smallint not null,
    id_atendimento smallint,
    foreign key (id_atendimento) references atendimento
);
