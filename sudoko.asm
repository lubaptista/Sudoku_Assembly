TITLE Sudoku em Assembly
.model small
.data
  linha EQU 9
  coluna EQU 9

  mat_sol DB 1, 4, 6, 9, 2, 3, 5, 7, 8
          DB 8, 3, 9, 7, 5, 4, 2, 6, 1
          DB 2, 7, 5, 1, 6, 8, 3, 9, 4
          DB 5, 9, 7, 8, 3, 1, 6, 4, 2
          DB 6, 1, 8, 4, 7, 2, 9, 3, 5
          DB 3, 2, 4, 5, 9, 6, 1, 8, 7
          DB 9, 5, 1, 6, 4, 7, 8, 2, 3
          DB 4, 6, 3, 2, 8, 5, 7, 1, 9
          DB 7, 8, 2, 3, 1, 9, 4, 5, 6

  mat_pr  DB 1, 4, ?, ?, 2, ?, 5, ?, 8
          DB ?, ?, 9, 7, 5, ?, ?, 6, ?
          DB 2, ?, ?, 1, ?, ?, 3, ?, ?
          DB ?, 9, 7, ?, 3, ?, 6, 4, ?
          DB ?, ?, 8, ?, ?, 2, ?, ?, 5
          DB 3, ?, ?, 5, ?, ?, 1, ?, ?
          DB ?, 5, ?, 6, ?, ?, ?, 2, 3
          DB ?, 6, ?, ?, ?, 5, 7, ?, ?
          DB 7, ?, 2, 3, 1, ?, 4, ?, ?



  abertura DB 10, "-----------------------------------------------------", '$'
  introd DB 10, "              SUDOKU EM ASSEMBLY", '$'
  fecha DB 10, "-----------------------------------------------------", '$'
  intro DB 10, '  Complete o jogo abaixo com numeros de 1 a 9,', 10, " sem repeti-los na mesma linha, coluna ou quadrante!!", '$'
  denovo DB 10, 10, ' Refazer o jogo anterior -> (1)', 10, ' Tentar um novo jogo -> (2)', 10, ' Sair do programa -> (3)', 10, '$'

.code
 ; macro para pular linha:
  pula MACRO                             
     MOV AH, 02                               ; funcao para impressao de caractere
     MOV DL, 10                               ; mover para DL o codigo ascii do <pula linha> -> 10h
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
  ENDM

 ; macro para dar espaco:
  espaco MACRO
     MOV AH, 02                               ; funcao para impressao de caractere
     MOV DL, " "                              ; mover para DL o caractere a ser impresso, <espaco> (para padronizacao na impressao)
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
  ENDM

 ; macro para fazer push de registradores
  r_push  MACRO 
     PUSH AX                                  ; salva os conteudos de AX 
     PUSH BX                                  ; salva os conteudos de BX 
     PUSH CX                                  ; salva os conteudos de CX 
     PUSH DX                                  ; salva os conteudos de DX 
     PUSH SI                                  ; salva os conteudos de SI
  ENDM 

 ; macro para fazer pop de registradores
  r_pop  MACRO 
     POP  SI                                  ; restaura os conteudos de SI
     POP  DX                                  ; restaura os conteudos de DX 
     POP  CX                                  ; restaura os conteudos de CX 
     POP  BX                                  ; restaura os conteudos de BX 
     POP  AX                                  ; restaura os conteudos de AX 
  ENDM

  add_linhav MACRO
     LOCAL impr
     CMP CL, 0
     JL  impr
     CMP CL, 8
     JL impr

     impr:
     MOV DL, 179                              ; move para DL o caractere 205 (linha de cima da tabela)
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
     espaco                                   ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 

  ENDM

  main PROC
     MOV AX, @DATA
     MOV DS, AX                               ; DS é o registrador que guarda o endereço do segmento de dados 

    inicio:
       CALL cabecalho                         ; chamada procedimento para impressao do cabecalho do programa -> 'cabecalho'
     
       MOV AH, 09                             ; funcao para impressao de string 
       LEA DX, intro                          ; coloca o endereco da mensagem 'intro' no registrador DX
       INT 21H                                ; executa funcao, imprimindo o conteudo do endereco DX          

       pula                                   ; chamada macro 'pula', para pular linha entre os caracteres impressos 
       pula                                   ; chamada macro 'pula', para pular linha entre os caracteres impressos 
     
       LEA BX, mat_pr
       CALL imprime_mat

    



       CALL mens_final                        ; chamada procedimento para impressao de mensagem final -> 'mens_final'
      ; analise resposta do usuario
       CMP AL, '1'                            ; compara conteudo de AL com o caractere '1'
       JMP inicio                             ; pula para o inicio do programa -> 'inicio'

       CMP AL, '2'                            ; compara conteudo de AL com o caractere '2'
       JMP muda                               ; pula para  -> 'muda'

       CMP AL, '3'                            ; compara conteudo de AL com o caractere '3'
       JMP fim                                ; pula para o final do programa -> 'fim'

    muda:
       ;CALL mudanca1                         ; chamada do procedimento para mudanca da matriz solucao


    fim:
       MOV AH, 4CH                            ; fim do programa
       INT 21H
  main ENDP


  cabecalho PROC
     r_push                                    ; chamada macro 'r_push', para salvar conteudos dos registradores

     MOV AH, 09                                ; funcao para impressao de string 
     LEA DX, abertura                          ; coloca o endereco da mensagem 'abertura' no registrador DX
     INT 21H                                   ; executa funcao, imprimindo o conteudo do endereco DX            
    
     MOV AH, 09                                ; funcao para impressao de string 
     LEA DX, introd                            ; coloca o endereco da mensagem 'introd' no registrador DX
     INT 21H                                   ; executa funcao, imprimindo o conteudo do endereco DX              
 
     MOV AH, 09                                ; funcao para impressao de string 
     LEA DX, fecha                             ; coloca o endereco da mensagem 'fecha' no registrador DX
     INT 21H                                   ; executa funcao, imprimindo o conteudo do endereco DX  

     pula                                      ; chamada macro 'pula', para pular linha entre os caracteres impressos  
     
     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
  cabecalho ENDP

  imprime_mat PROC  
     r_push                                    ; chamada macro 'r_push', para salvar conteudos dos registradores
    
     ;MOV AH, 02                                ; funcao para impressao de caracteres  
     pula      

     MOV DL, 201                               ; move para DL o caractere 201 (borda da tabela)
     INT 21H                                   ; executa funcao, imprimindo o conteudo de DL
     
     ;XOR CH, CH 
     MOV CH, 9                                 ; move o conteudo da 'linha' (9) para o registrador CH (contador)

    repet2:
     MOV CL, 4                                 ; move o conteudo de 'coluna' (9) para o registrador CL (contador de colunas)

    repet:
     MOV DL, 205                               ; move para DL o caractere 205 (linha de cima da tabela)
     INT 21H                                   ; executa funcao, imprimindo o conteudo de DL

     DEC CL                                    ; decrementa CH (contador)
     JNZ repet                                 ; enquanto CH nao for zero, voltar para repet
     
     MOV DL, 203                               ; move para DL o caractere 205 (linha de cima da tabela)
     INT 21H                                   ; executa funcao, imprimindo o conteudo de DL
  
     DEC CH
      JNZ repet2

     

     pula                                      ; chamada macro 'pula', para pular linha entre os caracteres impressos 

     MOV CH, linha                             ; move o conteudo da 'linha' (9) para o registrador CH (contador de linhas)

     muda_linha:                               ; loop interno (mudar de linha)
       MOV CL, coluna                          ; move o conteudo de 'coluna' (9) para o registrador CL (contador de colunas)
       XOR SI, SI                              ; operador XOR entre SI e SI, zerando o registrador SI, para percorrer as colunas 

     muda_coluna:                              ; loop externo (mudar coluna)
        espaco                                 ; chama macro 'espaco', para pular um espaco entre os caracteres impressos  
        
        add_linhav

        MOV DL, [BX][SI]                       ; move para DL o conteudo da matriz da linha BX (inicialmente corresponde ao endereco do primeiro elemento) e coluna SI (guarda a coluna)
        CMP DL,  ?                             ; comparar conteudo de DL com o caractere '?'
        JE nada                                ; pula para 'nada', se conteudo de DL igual ao caractere '?'

        ADD DL, 30h                            ; adiciona 30h no conteudo de DL (numero a ser impresso), para transformar o elemento da matriz em caractere parta impressao
        JMP imprime                            ; pula para 'imprime'

       nada: 
        MOV DL, ' '                            ; move para DL o caractere a ser impresso, <espaco> para existir um buraco no lugar do numero faltante

       imprime: 
        INT 21H                                ; executa funcao, imprimindo o conteudo de DL
        INC SI                                 ; ir para a prox linha
        DEC CL                                 ; decrementa CL (contador de colunas)
        JNZ muda_coluna                        ; enquanto CL nao for zero, pula para 'muda_coluna'

        pula                                   ; chama macro 'pula', para pular linha entre os caracteres impressos  

        ADD BX, coluna                         ; adiciona 'coluna' (quantidade de elementos da linha) com BX (endeco da linha lida)
        DEC CH                                 ; decrementa CH (contador de linhas)
        JNZ muda_linha                         ; enquanto CH nao for zero, pula para 'muda_linha'

     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
   imprime_mat  ENDP

   mens_final PROC

     MOV AH, 09                                ; funcao para impressao de string 
     LEA DX, denovo                            ; coloca o endereco da mensagem 'denovo' no registrador DX
     INT 21H                                   ; executa funcao, imprimindo o conteudo do endereco DX   

     XOR AL, AL                                ; operador XOR entre AL e AL, zerando o registrador AL, para armazenar a resposta do usuario (XOR entre numeros iguais = 0)

     MOV AH, 01                                ; funçao de leitura de caractere
     INT 21H                                   ; executa funcao, guardando o caractere inserido em AL

     RET
   mens_final ENDP

END main