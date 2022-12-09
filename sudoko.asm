TITLE Sudoku em Assembly
.model small
.data
  linha EQU 9
  coluna EQU 9
  linha2 DB ?
  COLUNA2 DB ?

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
  denovo DB 10, ' Refazer o jogo anterior -> (1)', 10, ' Tentar um novo jogo -> (2)', 10, ' Sair do programa -> (3)', 10, '$'
  digite DB 10, 'Digite o numero: ','$'
  ilinha DB 10, 'Digite a linha:', '$'
  icoluna DB 10, 'Digite coluna: ','$'
  erro DB 10, 'erro, insira novamente outro numero!','$'

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

 ; macro para imprimir string 
  imp_str MACRO STR 
    MOV AH,09
    LEA DX,STR
    INT 21H 
  ENDM

 ; macro para limpar e colorir a tela 
  limpa_cor MACRO
    MOV AX,0003H
    INT 10H                                  ; função que limpa a tela 
    MOV AH, 00H
    MOV AH, 09H
    MOV BH, 00H
    MOV AL, 20H
    MOV CX, 800H
    MOV BL, 5FH                              ; cor desejada (roxo)
    INT 10H                                  ; chama o sistema operacional para realizar a função 
  ENDM

 ; macro para fazer push de registradores:
  r_push  MACRO 
     PUSH AX                                  ; salva os conteudos de AX 
     PUSH BX                                  ; salva os conteudos de BX 
     PUSH CX                                  ; salva os conteudos de CX 
     PUSH DX                                  ; salva os conteudos de DX 
     PUSH SI                                  ; salva os conteudos de SI
  ENDM 

 ; macro para fazer pop de registradores:
  r_pop  MACRO 
     POP  SI                                  ; restaura os conteudos de SI
     POP  DX                                  ; restaura os conteudos de DX 
     POP  CX                                  ; restaura os conteudos de CX 
     POP  BX                                  ; restaura os conteudos de BX 
     POP  AX                                  ; restaura os conteudos de AX 
  ENDM

 ; macro para funcao 'LOCAL', nescessário na macro 'add_linha1h'
  mlocal MACRO
      LOCAL repet
      LOCAL repet2
      LOCAL dif
      LOCAL imp
      LOCAL carac_final
  ENDM

 ; macro para impressao da primeira linha de caracteres ("=") da tabela:
  add_linha1h MACRO
     mlocal                                   ; chamada macro 'mlocal'

     pula                                     ; chamada macro 'pula', para pular linha entre os caracteres impressos  
     espaco                                   ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 

     MOV DL, 201                              ; move para DL o caractere 201 (borda esquerda superior da tabela)
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
     
     MOV CH, coluna                           ; move o conteudo da 'coluna'(9) para o registrador CH (contador)

     repet2:
       MOV CL, 3                              ; move o numero 3 para o registrador CL (contador), pois 1 "numero" do sudoko possui espaco de 3 simbolos "="

     repet:
       MOV DL, 205                            ; move para DL o caractere 205 (linha de cima da tabela)
       INT 21H                                ; executa funcao, imprimindo o conteudo de DL

       DEC CL                                 ; decrementa CL (contador de simbulo por "quadrado")
       JNZ repet                              ; enquanto CH nao for zero, voltar para repet
     
       CMP CH, 1                              ; compara o conteudo de CH(contador de "quadrados") com 1, para verificar se está sendo impresso o elemento da ultima coluna)
       JE carac_final                         ; pular para 'carac_final', se CH for igual a 'coluna', para imprimir o caractere do final da linha

       CMP CH, 7                              ; compara o conteudo de CH(contador de "quadrados") com 7, para verificar se está sendo impresso o elemento da terceira coluna)
       JE dif                                 ; salta para 'dif', se CH fro igual a 7
       CMP CH, 4                              ; compara o conteudo de CH(contador de "quadrados") com 4, para verificar se está sendo impresso o elemento da sexta coluna)
       JE dif                                 ; salta para 'dif', se CH fro igual a 4
       
       JMP imp                                ; salta para imp

     dif:
       MOV DL, 203                            ; move para DL o caractere 203 (linha da tabela com ligacao para baixo)
       
       JMP imp                                ; pular para 'imp'

     carac_final:
       MOV DL, 187                            ; move para DL o caractere 187 (borda direita superior da tabela)

     imp:
       INT 21H                                ; executa funcao, imprimindo o conteudo de DL

       DEC CH                                 ; decrementa CH (contador de "quadrados")
       JNZ repet2                             ; pular para 'repet2', enquanto CH nao for zero

       pula                                   ; chamada macro 'pula', para pular linha entre os caracteres impressos 
  ENDM

 ; macro para impressao do separador vertical simples entre os numeros:
  add_linhav MACRO
     espaco                                   ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 
     MOV DL, 179                              ; move para DL o caractere 179 (linha vertical simples da tabela)
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
     espaco                                   ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 
  ENDM

 ; macro para impressao do separador vertical duplo entre os numeros:
  add_linha2v MACRO
     espaco                                   ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 
     MOV DL, 186                              ; move para DL o caractere 186 (linha vertical dupla da tabela)
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
     espaco                                   ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 
  ENDM 

  main PROC
     MOV AX, @DATA
     MOV DS, AX                               ; DS é o registrador que guarda o endereço do segmento de dados 

     limpa_cor

    inicio:
       CALL cabecalho                         ; chamada procedimento para impressao do cabecalho do programa -> 'cabecalho'
     
       ;pula                                   ; chamada macro 'pula', para pular linha entre os caracteres impressos 
     
       LEA BX, mat_pr
       CALL imprime_mat

       CALL linhaa1
       CALL linhaa2



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

     MOV AH, 09                                ; funcao para impressao de string 
     LEA DX, intro                             ; coloca o endereco da mensagem 'intro' no registrador DX
     INT 21H                                   ; executa funcao, imprimindo o conteudo do endereco DX          

     pula                                      ; chamada macro 'pula', para pular linha entre os caracteres impressos 
     
     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
  cabecalho ENDP

  impa proc 
     r_push                                    ; chamada macro 'r_push', para salvar conteudos dos registradores

     MOV linha2,9
     MOV COLUNA2,9
     LEA BX, mat_pr
     CALL imprime_mat

     pula

     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     ret 
  impa ENDP

  inserir PROC 
    r_push
    XOR AX,AX
    XOR SI,SI 
    pula
    MOV AH,BH
    MOV BX,CX                                 ; BX contem o numero da posição da linha 
    XOR CX,CX                                 ; zera CX
    MOV CX,1

    linha1:
MOV mat_pr[BX][SI],AH                        ; move AH para a posição desejada 
LOOP linha1
pula
CALL IMPA
RET 
inserir ENDP 

linhaa1 proc
INICIO1:
 MOV AH, 09                                ; funcao para impressao de string 
 LEA DX, ilinha                            ; coloca o endereco da mensagem 'denovo' no registrador DX
 INT 21H
 MOV AH,01                                 ; executa funcao, imprimindo o conteudo do endereco DX
 INT 21H 
 MOV CH,AL
 SUB CH,30H
 CMP CH,1
 JE COLUNA1
 JMP FINAL

COLUNA1: 
 MOV AH, 09                                ; funcao para impressao de string 
 LEA DX, icoluna                           ; coloca o endereco da mensagem 'denovo' no registrador DX
 INT 21H
 MOV AH,01                                 ; executa funcao, imprimindo o conteudo do endereco DX
 INT 21H 
 MOV CL,AL
 SUB CL, 30H

 CMP CL,3
JE COLUNA3
CMP CL,4
JE COLUNA4
CMP CL,6
JE COLUNA6
CMP CL,8
JE COLUNA8

COLUNA3:
MOV AH,09H
LEA DX, digite                            ; coloca o endereco da mensagem 'denovo' no registrador DX
INT 21H
MOV AH,01                                 ; executa funcao, imprimindo o conteudo do endereco DX
INT 21H 
MOV BH,AL
SUB BH, 30H
CMP BH,6
JE CERTO
JMP ERRO1

COLUNA4:
MOV AH,09H
LEA DX, digite                            ; coloca o endereco da mensagem 'denovo' no registrador DX
INT 21H
MOV AH,01                                 ; executa funcao, imprimindo o conteudo do endereco DX
INT 21H 
MOV BH,AL
SUB BH, 30H
CMP BH,9
JE CERTO
JMP ERRO1

COLUNA6:
MOV AH,09H
LEA DX, digite                            ; coloca o endereco da mensagem 'denovo' no registrador DX
INT 21H
MOV AH,01                                 ; executa funcao, imprimindo o conteudo do endereco DX
INT 21H 
MOV BH,AL
SUB BH, 30H
CMP BH,3
JE CERTO
JMP ERRO1

COLUNA8:
MOV AH,09H
LEA DX, digite                            ; coloca o endereco da mensagem 'denovo' no registrador DX
INT 21H
MOV AH,01                                 ; executa funcao, imprimindo o conteudo do endereco DX
INT 21H 
MOV BH,AL
SUB BH, 30H
CMP BH,7
JE CERTO
JMP ERRO1



CERTO: 
 XOR CH,CH 
 DEC CL 
 CALL inserir
 JMP FINAL
ERRO1: 
MOV AH,09H
 LEA DX, ERRO                             ; coloca o endereco da mensagem 'denovo' no registrador DX
 INT 21H
 JMP INICIO1
 
FINAL: 
RET
linhaa1 endp

  imprime_mat PROC  
     r_push                                    ; chamada macro 'r_push', para salvar conteudos dos registradores
    
     add_linha1h                               ; chamada macro 'add_linha1h', para impressao da linha de cima da tabela
     MOV CH, linha                             ; move o conteudo da 'linha' (9) para o registrador CH (contador de linhas)

     muda_linha:                               ; loop interno (mudar de linha)
       MOV CL, coluna                          ; move o conteudo de 'coluna' (9) para o registrador CL (contador de colunas)
       XOR SI, SI                              ; operador XOR entre SI e SI, zerando o registrador SI, para percorrer as colunas 
       MOV DH, 3                               ; move 3 para DH (contador para impresssao das divisórias)

     muda_coluna:                              ; loop externo (mudar coluna)
        CMP DH, 3                              ; compara DH (contador para impresssao das divisórias) com 3, para adicionar linha dupla neste caso
        JNE l_basica                           ; se DH nao for igual a 3, pula para 'l_basica'

        add_linha2v                            ; chamada macro 'add_linha2v', para impressão de linha dupla vertical
        JMP cont                               ; pula para 'cont'

     l_basica:
        CMP DH, 0                              ; compara conteudo de DH com 0
        JNE lin                                ; salta para 'lin', se DH nao for igual a 0

        MOV DH, 3                              ; move 3 para DH (contador para impresssao das divisórias)
        JMP muda_coluna                        ; salta para 'muda_coluna'
     
     lin:
        add_linhav                             ; chamada macro 'add_linhav', para impressão de linha simples vertical           

     cont:
        MOV DL, [BX][SI]                       ; move para DL o conteudo da matriz da linha BX (inicialmente corresponde ao endereco do primeiro elemento) e coluna SI (guarda a coluna)
        CMP DL,  ?                             ; compara conteudo de DL com o caractere '?'
        JE nada                                ; pula para 'nada', se conteudo de DL igual ao caractere '?'
 
        ADD DL, 30h                            ; adiciona 30h no conteudo de DL (numero a ser impresso), para transformar o elemento da matriz em caractere parta impressao
        JMP imprime                            ; pula para 'imprime'

     nada: 
        MOV DL, ' '                            ; move para DL o caractere a ser impresso, <espaco> para existir um buraco no lugar do numero faltante

     imprime: 
        INT 21H                                ; executa funcao, imprimindo o conteudo de DL

        INC SI                                 ; incrementa SI, para imprimir a proxima linha
        DEC DH                                 ; decrementa DH (contador para impresssao das divisórias)
        
        DEC CL                                 ; decrementa CL (contador de colunas)
        JNZ muda_coluna                        ; enquanto CL nao for zero, pula para 'muda_coluna'
        
        add_linha2v                            ; chamada macro 'add_linha2v', para impressão de linha dupla vertical
        pula                                   ; chama macro 'pula', para pular linha entre os caracteres impressos

        CMP CH, 7 
        JE linhadup
        CMP CH, 4
        JE linhadup
        JMP cont2
        
     linhadup:
       CALL add_linha3h

     cont2:
        ADD BX, coluna                         ; adiciona 'coluna' (quantidade de elementos da linha) com BX (endeco da linha lida)
        DEC CH                                 ; decrementa CH (contador de linhas)
        JNZ muda_linha                         ; enquanto CH nao for zero, pula para 'muda_linha'

        CALL add_linha2h

     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
   imprime_mat  ENDP

 ; procedimento para impressao da ultima linha de caracteres ("=") da tabela:
  add_linha2h PROC
     r_push                                   ; chamada macro 'r_push', para salvar conteudos dos registradores
     espaco                                   ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 

     MOV DL, 200                              ; move para DL o caractere 200 (borda esquerda inferior da tabela) 
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
     
     MOV CH, coluna                           ; move o conteudo da 'coluna'(9) para o registrador CH (contador)

     repet4:
       MOV CL, 3                              ; move o numero 3 para o registrador CL (contador), pois 1 "numero" do sudoko possui espaco de 3 simbolos "="

     repet3:
       MOV DL, 205                            ; move para DL o caractere 205 (linha de cima da tabela)
       INT 21H                                ; executa funcao, imprimindo o conteudo de DL

       DEC CL                                 ; decrementa CL (contador de simbulo por "quadrado")
       JNZ repet3                             ; enquanto CH nao for zero, voltar para 'repet3'
     
       CMP CH, 1                              ; compara o conteudo de CH(contador de "quadrados") com 1, para verificar se está sendo impresso o elemento da ultima coluna)
       JE carac_final2                        ; pular para 'carac_final2', se CH for igual a 'coluna', para imprimir o caractere do final da linha

       CMP CH, 7                              ; compara o conteudo de CH(contador de "quadrados") com 7, para verificar se está sendo impresso o elemento da terceira coluna)
       JE dif2                                ; salta para 'dif2', se CH fro igual a 7
       CMP CH, 4                              ; compara o conteudo de CH(contador de "quadrados") com 4, para verificar se está sendo impresso o elemento da sexta coluna)
       JE dif2                                ; salta para 'dif2', se CH fro igual a 4
       
       JMP imp2                               ; salta para 'imp2'

     dif2:
       MOV DL, 202                            ; move para DL o caractere 202 (linha da tabela com ligacao para cima)
       
       JMP imp2                               ; pular para 'imp2'

     carac_final2:
       MOV DL, 188                            ; move para DL o caractere 188 (borda direita inferior da tabela)

     imp2:
       INT 21H                                ; executa funcao, imprimindo o conteudo de DL
       DEC CH                                 ; decrementa CH (contador de "quadrados")
       JNZ repet4                             ; pular para 'repet4', enquanto CH nao for zero

       pula                                   ; chamada macro 'pula', para pular linha entre os caracteres impressos 
     
     r_pop                                    ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
  add_linha2h ENDP

 ; procedimento para impressao da linha central de caracteres ("=") da tabela:
  add_linha3h PROC
     r_push                                   ; chamada macro 'r_push', para salvar conteudos dos registradores
     espaco                                   ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 

     MOV DL, 204                              ; move para DL o caractere 204 (lateral esquerda meio da tabela) 
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
     
     MOV CH, coluna                           ; move o conteudo da 'coluna'(9) para o registrador CH (contador)

     repet6:
       MOV CL, 3                              ; move o numero 3 para o registrador CL (contador), pois 1 "numero" do sudoko possui espaco de 3 simbolos "="

     repet5:
       MOV DL, 205                            ; move para DL o caractere 205 (linha de cima da tabela)
       INT 21H                                ; executa funcao, imprimindo o conteudo de DL

       DEC CL                                 ; decrementa CL (contador de simbulo por "quadrado")
       JNZ repet5                             ; enquanto CH nao for zero, voltar para 'repet5'
     
       CMP CH, 1                              ; compara o conteudo de CH(contador de "quadrados") com 1, para verificar se está sendo impresso o elemento da ultima coluna)
       JE carac_final3                        ; pular para 'carac_final3', se CH for igual a 'coluna', para imprimir o caractere do final da linha

       CMP CH, 7                              ; compara o conteudo de CH(contador de "quadrados") com 7, para verificar se está sendo impresso o elemento da terceira coluna)
       JE dif3                                ; salta para 'dif3', se CH fro igual a 7
       CMP CH, 4                              ; compara o conteudo de CH(contador de "quadrados") com 4, para verificar se está sendo impresso o elemento da sexta coluna)
       JE dif3                                ; salta para 'dif3', se CH fro igual a 4
       
       JMP imp3                               ; salta para 'imp3'

     dif3:
       MOV DL, 206                            ; move para DL o caractere 206 (simbulo meio da tabela com ligacao para todos os lados)
       
       JMP imp3                               ; pular para 'imp3'

     carac_final3:
       MOV DL, 185                            ; move para DL o caractere 185 (lateral direita central da tabela)

     imp3:
       INT 21H                                ; executa funcao, imprimindo o conteudo de DL
       DEC CH                                 ; decrementa CH (contador de "quadrados")
       JNZ repet6                             ; pular para 'repet6', enquanto CH nao for zero

       pula                                   ; chamada macro 'pula', para pular linha entre os caracteres impressos 

       r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
       RET
  add_linha3h ENDP

 ; procedimento para impressao da linha central dentro dos "quadrados" de caracteres ("=") da tabela:
  add_linha4h PROC
     r_push                                   ; chamada macro 'r_push', para salvar conteudos dos registradores
     pula
     espaco                                   ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 

     MOV DL, 186                              ; move para DL o caractere 186 (linha vertical dupla da tabela) 
     INT 21H                                  ; executa funcao, imprimindo o conteudo de DL
     
     MOV CH, coluna                           ; move o conteudo da 'coluna'(9) para o registrador CH (contador)

     repet8:
       MOV CL, 3                              ; move o numero 3 para o registrador CL (contador), pois 1 "numero" do sudoko possui espaco de 3 simbolos "="

     repet7:
       MOV DL, 205                            ; move para DL o caractere 205 (linha de cima da tabela)
       INT 21H                                ; executa funcao, imprimindo o conteudo de DL

       DEC CL                                 ; decrementa CL (contador de simbulo por "quadrado")
       JNZ repet7                             ; enquanto CH nao for zero, voltar para 'repet7'
     
       CMP CH, 1                              ; compara o conteudo de CH(contador de "quadrados") com 1, para verificar se está sendo impresso o elemento da ultima coluna)
       JE carac_final4                        ; pular para 'carac_final4', se CH for igual a 'coluna', para imprimir o caractere do final da linha

       CMP CH, 7                              ; compara o conteudo de CH(contador de "quadrados") com 7, para verificar se está sendo impresso o elemento da terceira coluna)
       JE dif4                                ; salta para 'dif4', se CH fro igual a 7
       CMP CH, 4                              ; compara o conteudo de CH(contador de "quadrados") com 4, para verificar se está sendo impresso o elemento da sexta coluna)
       JE dif4                                ; salta para 'dif4', se CH fro igual a 4
       
       JMP imp4                               ; salta para 'imp4'

     dif4:
       MOV DL, 206                            ; move para DL o caractere 206 (simbulo meio da tabela com ligacao para todos os lados)
       
       JMP imp4                               ; pular para 'imp4'

     carac_final4:
       MOV DL, 185                            ; move para DL o caractere 185 (lateral direita central da tabela)

     imp4:
       INT 21H                                ; executa funcao, imprimindo o conteudo de DL
       DEC CH                                 ; decrementa CH (contador de "quadrados")
       JNZ repet8                             ; pular para 'repet8', enquanto CH nao for zero

       ;pula                                   ; chamada macro 'pula', para pular linha entre os caracteres impressos 

       r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
       RET
  ENDP

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