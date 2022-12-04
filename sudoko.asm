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
  intro DB '  Complete o jogo abaixo com numeros de 1 a 9,', 10, " sem repeti-los na mesma linha, coluna ou quadrante!!", '$'

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
     MOV DL, " "                              ; mover para DL o número a ser impresso, <espaco> (para padronizacao na impressao)
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
  ENDM

  main PROC
     MOV AX, @DATA
     MOV DS, AX                                ; DS é o registrador que guarda o endereço do segmento de dados 

     CALL cabecalho                            ; chamada procedimento para impressao do cabecalho do programa -> 'cabecalho'
     
     MOV AH, 09                                ; funcao para impressao de string 
     LEA DX, intro                             ; coloca o endereco da mensagem 'intro' no registrador DX
     INT 21H                                   ; executa funcao, imprimindo o conteudo do endereco DX          

     pula
     pula
     
     LEA BX, mat_pr
     CALL imprime_mat

    





     MOV AH, 4CH
     INT 21H

  main ENDP

  cabecalho PROC
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

     RET
  cabecalho ENDP

  imprime_mat PROC  
     
     
     MOV CH, linha                             ; move o conteudo da 'linha' (9) para o registrador CH (contador de linhas)
     MOV AH, 02                                ; funcao para impressao de caracteres              

     muda_linha:                               ; loop interno (mudar de linha)
       MOV CL, coluna                          ; move o conteudo de 'coluna' (9) para o registrador CL (contador de colunas)
       XOR SI, SI                              ; operador XOR entre SI e SI, zerando o registrador SI, para percorrer as colunas 

     muda_coluna:                              ; loop externo (mudar coluna)
        espaco                                 ; chama macro 'espaco', para pular um espaco entre os caracteres impressos  

        MOV DL, [BX][SI]                       ; move para DL o conteudo da matriz da linha BX (inicialmente corresponde ao endereco do primeiro elemento) e coluna SI (guarda a coluna)
        ADD DL, 30h                            ; adiciona 30h no conteudo de DL (numero a ser impresso), para transformar o elemento da matriz em caractere parta impressao
        INT 21H                                ; executa funcao, imprimindo o conteudo de DL
        INC SI                                 ; ir para a prox linha
        DEC CL                                 ; decrementa CL (contador de colunas)
        JNZ muda_coluna                        ; enquanto CL nao for zero, pula para 'muda_coluna'

        pula                                   ; chama macro 'pula', para pular linha entre os caracteres impressos  

        ADD BX, coluna                         ; adiciona 'coluna' (quantidade de elementos da linha) com BX (endeco da linha lida)
        DEC CH                                 ; decrementa CH (contador de linhas)
        JNZ muda_linha                         ; enquanto CH nao for zero, pula para 'muda_linha'

     RET
   imprime_mat  ENDP



END main