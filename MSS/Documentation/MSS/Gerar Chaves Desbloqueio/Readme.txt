A estrutura do código gerado nos terminais pode variar, sendo que é composto pela seguinte informação.
Os primeiros 2 caracteres do primeiro bloco são o código de tipo de erro:
                01 – Cliente bloqueado;
                02 – Cliente sem crédito;
                03 – Cliente com documentos vencidos;
                04 – Impressão bloqueada;
                05 – Descontos máximos ultrapassados;
                06 – Desconto de recibo ultrapassado;
                08 – Desbloquear alteração do escalão de preço;
                09 – Desbloqueio de alteração de preço ou descontos;
	  10 – Desbloquear desconto máximo;
                11 – Preço ou desconto bloqueado;
                12 – Cliente bloqueado;
                13 – Cliente com documentos vencidos;
                14 – Sincronizar sem iniciar o dia;
                15 – Vendedor sem crédito;
                16 – Só administrador pode criar novo documento;
                17 – Só pode anular com código de desbloqueio;
 
Em função do tipo de erro os vários blocos representam os seguintes valores:
                1 – Código Erro – Código documento – Cliente
                2 – Código Erro – Código documento – Cliente
                3 – Código Erro – Código documento – Cliente
                4 – Código Erro – Código documento – Série – Número 
                5 – Código Erro – Código documento – Cliente – Artigo – Preço – Desconto 1 – Desconto 2 – Desconto 3 – Desconto 4 
                6 – Código Erro – Código documento – Cliente
                8 – Código Erro – Código documento – Cliente – Escalão de preço
                9 – Código Erro – Código documento – Cliente – Artigo – Preço – Desconto 1 – Desconto 2 – Desconto 3 – Desconto 4 
                10 – Código Erro – Código documento – Cliente
                11 – Código Erro – Código documento – Cliente
                12 – Código Erro –Cliente
                13 – Código Erro –Cliente
                14 – Código Erro 
                15 – Código Erro – Código documento – Cliente
                16 – Código Erro – Código documento
                17 – Código Erro – Código documento – Série – Número – Cliente
