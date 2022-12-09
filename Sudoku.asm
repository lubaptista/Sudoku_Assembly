 TITLE Beatriz Newman, RA: 22002150 / Luana Baptista, RA: 22006563
.model small
.data
  linha EQU 9
  coluna EQU 9
  erros DB 0

  mat_sol DB 1, 4, 6, 9, 2, 3, 5, 7, 8
          DB 8, 3, 9, 7, 5, 4, 2, 6, 1
          DB 2, 7, 5, 1, 6, 8, 3, 9, 4
          DB 5, 9, 7, 8, 3, 1, 6, 4, 2
          DB 6, 1, 8, 4, 7, 2, 9, 3, 5
          DB 3, 2, 4, 5, 9, 6, 1, 8, 7
          DB 9, 5, 1, 6, 4, 7, 8, 2, 3
          DB 4, 6, 3, 2, 8, 5, 7, 1, 9
          DB 7, 8, 2, 3, 1, 9, 4, 5, 6

  mat2_sol DB 5, 3, 4, 6, 7, 8, 9, 1, 2
           DB 6, 7, 2, 1, 9, 5, 3, 4, 8
           DB 1, 9, 8, 3, 4, 2, 5, 6, 7
           DB 8, 5, 9, 7, 6, 1, 4, 2, 3
           DB 4, 2, 6, 8, 5, 3, 7, 9, 1
           DB 7, 1, 3, 9, 2, 4, 8, 5, 6
           DB 9, 6, 1, 5, 3, 7, 2, 8, 4
           DB 2, 8, 7, 4, 1, 9, 6, 3, 5
           DB 3, 4, 5, 2, 8, 6, 1, 7, 9

  mat_pr  DB 1, 4, '_', '_', 2, '_', 5, '_', 8
          DB '_', '_', 9, 7, 5, '_', '_', 6, '_'
          DB 2, '_', '_', 1, '_', '_', 3, '_', '_'
          DB '_', 9, 7, '_', 3, '_', 6, 4, '_'
          DB '_', '_', 8, '_', '_', 2, '_', '_', 5
          DB 3, '_', '_', 5, '_', '_', 1, '_', '_'
          DB '_', 5, '_', 6, '_', '_', '_', 2, 3
          DB '_', 6, '_', '_', '_', 5, 7, '_', '_'
          DB 7, '_', 2, 3, 1, '_', 4, '_', '_'

  mat2_pr DB 5, 3, '_', '_', 7, '_', '_', '_', '_'
          DB 6, '_', '_', 1, 9, 5, '_', '_', '_'
          DB '_', 9, 8, '_', '_', '_', '_', 6, '_'
          DB 8, '_', '_', '_', 6, '_', '_', '_', 3
          DB 4, '_', '_', 8, '_', 3, '_', '_', 1
          DB 7, '_', '_', '_', 2, '_', '_', '_', 6
          DB '_', 6, '_', '_', '_', '_', 2, 8, '_'
          DB '_', '_', '_', 4, 1, 9, '_', '_', 5
          DB '_', '_', '_', '_', 8, '_', '_', 7, 9
          
  abertura DB 10, "-----------------------------------------------------", '$'
  introd DB 10, "              SUDOKU EM ASSEMBLY", '$'
  fecha DB 10, "-----------------------------------------------------", '$'
  intro DB 10, '  Complete o jogo abaixo com numeros de 1 a 9,', 10, " sem repeti-los na mesma linha, coluna ou quadrante!!", '$'
  denovo DB 10, 10, 10, 10, 10, ' Refazer o jogo anterior -> (1)', 10, ' Tentar um novo jogo -> (2)', 10, ' Sair do programa -> (3)', 10, 10, '$'
  denovo2 DB 10, 10, 10, 10, 10, ' Refazer o jogo anterior -> (1)', 10, 'Repetir o primeiro jogo realizado -> (2)', 10, ' Sair do programa -> (3)', 10, 10, '$'
  digite DB 10, 'Digite o numero: ','$'
  ilinha DB 10, 'Digite a linha:', '$'
  icoluna DB 10, 'Digite coluna: ','$'
  erro DB 10, ' Tente novamente! Voce so pode cometer 5 erros, cuidado!','$'
  erro_comet DB 10, ' Erros cometidos: ', '$'
  erro1 DB 10, ' Posicao nao pode ser alterada, tente inserir outra linha e coluna!', '$'
  perda DB 10, 10, 10, 10, 10, 10, '                GAME OVER!!', 10, 10, 10,10, '    Voce cometeu 5 erros!',10, '$'

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

 ; macro para imprimir string (AH 09 - INT 21H):
  imp_str MACRO STR 
     MOV AH,09                                ; funcao para impressao de string 
     LEA DX,STR                               ; coloca o endereco da mensagem 'str' (sera passada na chamada da macro) no registrador DX
     INT 21H                                  ; executa funcao, imprimindo o conteudo do endereco DX  
  ENDM

 ; macro que faz leitura (AH 01 - INT 21H):
  faz_leitura MACRO
     MOV AH,01                                ; funçao de leitura de caractere(para leitura da operacao a ser realizada)
     INT 21H                                  ; executa funcao, guardando o caractere inserido em AL
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

 ; macro para funcao 'LOCAL', nescessário na macro 'add_linha1h':
  mlocal MACRO
     LOCAL repet                              ; Informa ao montador que o label 'repet' eh local
     LOCAL repet2                             ; Informa ao montador que o label 'repet2' eh local
     LOCAL dif                                ; Informa ao montador que o label 'dif' eh local
     LOCAL imp                                ; Informa ao montador que o label 'imp' eh local
     LOCAL carac_final                        ; Informa ao montador que o label 'carac_final' eh local
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
       JNZ repet                              ; enquanto CH nao for zero, voltar para 'repet'
     
       CMP CH, 1                              ; compara o conteudo de CH(contador de "quadrados") com 1, para verificar se está sendo impresso o elemento da ultima coluna)
       JE carac_final                         ; salta para 'carac_final', se CH for igual a 'coluna', para imprimir o caractere do final da linha

       CMP CH, 7                              ; compara o conteudo de CH(contador de "quadrados") com 7, para verificar se está sendo impresso o elemento da terceira coluna)
       JE dif                                 ; salta para 'dif', se CH fro igual a 7
       CMP CH, 4                              ; compara o conteudo de CH(contador de "quadrados") com 4, para verificar se está sendo impresso o elemento da sexta coluna)
       JE dif                                 ; salta para 'dif', se CH fro igual a 4
       
       JMP imp                                ; salta para 'imp'

     dif:
       MOV DL, 203                            ; move para DL o caractere 203 (linha da tabela com ligacao para baixo)
       JMP imp                                ; salta para 'imp'

     carac_final:
       MOV DL, 187                            ; move para DL o caractere 187 (borda direita superior da tabela)

     imp:
       INT 21H                                ; executa funcao, imprimindo o conteudo de DL
       DEC CH                                 ; decrementa CH (contador de "quadrados")
       JNZ repet2                             ; salta para 'repet2', enquanto CH nao for zero

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
     MOV DS, AX                                ; DS é o registrador que guarda o endereço do segmento de dados 

     CALL limpa_cor                            ; chamada procedimento para limpar e colorir a tela -> 'limpa_cor'

     inicio:
       CALL cabecalho                          ; chamada procedimento para impressao do cabecalho do programa -> 'cabecalho'
     
       LEA BX, mat_pr                          ; coloca o endereco da matriz definida 'mat_pr' no registrador BX (linhas)
       CALL imprime_mat                        ; chamada procedimento para impressao da matriz -> 'imprime_mat'

       CALL inserir                            ; chamada procedimento para inserir caractere no jogo -> 'inserir'

     mensagem: 
       CALL mens_final                         ; chamada procedimento para impressao de mensagem final -> 'mens_final'
      
     ; analise resposta do usuario:
       CMP AL, '1'                             ; compara conteudo de AL com o caractere '1'
       JE inicio                               ; salta para o inicio do programa, se numero inserido for 1 -> 'inicio'

       CMP AL, '2'                             ; compara conteudo de AL com o caractere '2'
       JE muda                                 ; salta para mudar o jogo, se numero inserido for 2 -> 'muda'

       CMP AL, '3'                             ; compara conteudo de AL com o caractere '3'
       JE fim                                  ; salta para o final do programa, se numero inserido for -> 'fim'
       JMP mensagem                            ; salta para 'mensagem'

     muda:
       CALL cabecalho                          ; chamada procedimento para impressao do cabecalho do programa -> 'cabecalho'
 
       LEA BX, mat2_pr                         ; coloca o endereco da matriz definida 'mat2_pr' no registrador BX (linhas)
       CALL imprime_mat                        ; chamada procedimento para impressao da matriz -> 'imprime_mat'

       CALL inserir2                           ; chamada procedimento para inserir caractere no jogo -> 'inserir2'
      
      mens:
       CALL mens_final2                        ; chamada procedimento para impressao de mensagem final -> 'mens_final2'
      
      ; analise resposta do usuario:
       CMP AL, '1'                             ; compara conteudo de AL com o caractere '1'
       JE muda                                 ; salta para o inicio do jogo 2, se numero inserido for 1 -> 'muda'

       CMP AL, '2'                             ; compara conteudo de AL com o caractere '2'
       JE inicio                               ; salta para mudar para o jogo 1, se numero inserido for 2 -> 'inicio'

       CMP AL, '3'                             ; compara conteudo de AL com o caractere '3'
       JE fim                                  ; salta para o final do programa, se numero inserido for -> 'fim'
       JMP mens                                ; salta para 'mens'

    fim:
       MOV AH, 4CH                             ; fim do programa
       INT 21H
  main ENDP


 ; procedimento para impressao do cabecalho do programa
  cabecalho PROC
     r_push                                    ; chamada macro 'r_push', para salvar conteudos dos registradores

     imp_str abertura                          ; chamada macro 'imp_str', para impressao da mensagem 'abertura'          
     imp_str introd                            ; chamada macro 'imp_str', para impressao da mensagem 'introd'   
     imp_str fecha                             ; chamada macro 'imp_str', para impressao da mensagem 'fecha'   

     pula                                      ; chamada macro 'pula', para pular linha entre os caracteres impressos  

     imp_str intro                             ; chamada macro 'imp_str', para impressao da mensagem 'intro'          

     pula                                      ; chamada macro 'pula', para pular linha entre os caracteres impressos 
     
     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
  cabecalho ENDP

 ; procedimento para limpar e colorir a tela:
  limpa_cor PROC
     r_push                                    ; chamada macro 'r_push', para salvar conteudos dos registradores

     MOV AX,0003H                              ; função que limpa a tela 
     INT 10H                                   ; executa funcao
     MOV AH, 09H                               ; move 09H para o registrador AH
     MOV BH, 00H                               ; move 00H para o registrador BH
     MOV AL, 20H                               ; move 20H para o registrador AL
     MOV CX, 800H                              ; move 800H para o registrador CX
     MOV BL, 5FH                               ; move 5FH para o registrador BL, passando para ele o codigo da cor desejada (roxo)
     INT 10H                                   ; chama o sistema operacional para realizar a função 

     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
  limpa_cor ENDP

 ; procedimento para inserir caractere no jogo1:
  inserir PROC 
     r_push                                    ; chamada macro 'r_push', para salvar conteudos dos registradores

     comeco: 
       imp_str ilinha                          ; chamada macro 'imp_str', para impressao da mensagem 'ilinha'    
       faz_leitura                             ; chamada macro 'faz_leitura', para fazer leitura de um caractere  
       XOR AH, AH                              ; operador XOR entre AH e AH, zerando o registrador AH, para AX possuir so conteudo de AL (XOR entre numeros iguais = 0)
       MOV BX, AX                              ; move conteúdo de AX (numero inserido) para o registrador BX (linha)
       SUB BX, 30h                             ; subtrai o numero hexadecimal 30h do conteudo de BX, obtendo o valor decimal em BX

       imp_str icoluna                         ; chamada macro 'imp_str', para impressao da mensagem 'icoluna'  
       faz_leitura                             ; chamada macro 'faz_leitura', para fazer leitura de um caractere  
       XOR AH, AH                              ; operador XOR entre AH e AH, zerando o registrador AH, para AX possuir so conteudo de AL (XOR entre numeros iguais = 0)
       MOV SI, AX                              ; move conteúdo de AX (numero inserido) para o registrador SI (coluna) 
       SUB SI, 30h                             ; subtrai o numero hexadecimal 30h do conteudo de SI e , obtendo o valor decimal em SI

       imp_str digite                          ; chamada macro 'imp_str', para impressao da mensagem 'digite'
       faz_leitura                             ; chamada macro 'faz_leitura', para fazer leitura de um caractere 
       MOV DH, AL                              ; move conteúdo de AL (numero inserido) para o registrador DH (numero a ser inserido no sudoku) 
       SUB DH, 30h                             ; subtrai o numero hexadecimal 30h do conteudo de DH, obtendo o valor decimal em DH
       
       DEC SI                                  ; decrementa SI (coluna), pois a contagem  de colunas inicializa em 0, nao em 1
       DEC BX                                  ; decrementa BX (linha), pois a contagem  de colunas inicializa em 0, nao em 1
       MOV CH, linha                           ; move o conteudo da 'linha' (9) para o registrador CH (contador de linhas)
       XCHG AX, BX                             ; realiza uma troca (exchange) de conteudo entre os registradores AX (usado na MUL) e BX (linha)               
       MUL CH                                  ; o registrador AX eh o multiplicando e o CH (linha=9) eh o multiplicador
       XCHG AX, BX                             ; realiza uma troca (exchange) de conteudo entre os registradores AX e BX (voltando valores antes da multiplicacao)

       XOR CX, CX                              ; operador XOR entre CX e CX, zerando o registrador CX (XOR entre numeros iguais = 0)

       MOV CH, mat_pr[BX][SI]                  ; move o conteudo da linha BX e coluna SI da 'mat_pr' para o registrador CH 
       CMP CH , '_'                            ; compara o conteudo do registrador CH com <anderline> ('_')
       JNE nao                                 ; salta para 'nao', se CH nao for '_', ou seja, nao eh um espaco livre para receber valor

       
       MOV CH, mat_sol[BX][SI]                 ; move o conteudo da linha BX e coluna SI da 'mat_sol' para o registrador CH 
       CMP CH, DH                              ; compara o conteudo do registrador CH (resposta correta da posicao) com o de DH (caractere adicionado pelo usuario)
       JE correto                              ; salta para 'correto', se CH for igual a DH

       INC erros                               ; incrementa 'erros' (contador de erros)
       CMP erros, 5                            ; compara 'erros' com 5 (numero maximo de erros)
       JE perdeu                               ; salta para 'perdeu', se 'erros' for igual a 5

       imp_str erro_comet                      ; chamada macro 'imp_str', para impressao da mensagem 'erro_comet'
       MOV AH, 02                              ; funcao para impressao de caractere
       MOV DL, erros                           ; move o numero de 'erros' cometidos para o registrador DL 
       ADD DL, 30h                             ; soma o numero hexadecimal 30h ao conteudo do registrador DL, obtendo o valor decimal em DL
       INT 21H                                 ; executa funcao, imprimindo o conteudo de DL
       imp_str erro                            ; chamada macro 'imp_str', para impressao da mensagem 'erro' 

       JMP comeco                              ; salta para 'comeco'

     correto: 
       MOV mat_pr[BX][SI], DH                  ; move o contudo do registrador DH (numero inserido pelo usuario) para a posicao linha BX e coluna SI da 'mat_pr' 
       LEA BX, mat_pr                          ; coloca o endereco da matriz 'mat_pr' no registrador BX (linhas)
       CALL imprime_mat                        ; chamada procedimento para impressao da matriz -> 'imprime_mat'
       pula                                    ; chamada macro 'pula', para pular linha entre os caracteres impressos
       JMP comeco                              ; salta para 'comeco'

     nao:
       imp_str erro1                           ; chamada macro 'imp_str', para impressao da mensagem 'erro1'
       JMP comeco                              ; salta para 'comeco'
       
     perdeu: 
       CALL limpa_cor                          ; chamada procedimento para limpar e colorir a tela -> 'limpa_cor'
       imp_str perda                           ; chamada macro 'imp_str', para impressao da mensagem 'perda'
       
     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
  inserir ENDP

 ; procedimento para impressao da matriz:
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
        CMP DL,  '_'                           ; compara conteudo de DL com o caractere '_'
        JE nada                                ; pula para 'nada', se conteudo de DL igual ao caractere '_'
 
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

        CMP CH, 7                              ; compara conteudo de CH com 7 (terceira coluna)
        JE linhadup                            ; salta para 'linhadup', se CH for igual a 7
        CMP CH, 4                              ; compara conteudo de CH com 4 (sexta coluna)
        JE linhadup                            ; salta para 'linhadup', se CH for igual a 4
        JMP cont2                              ; salta para 'cont2'
        
     linhadup:
       CALL add_linha3h                        ; chama procedimento 'add_linha3h', para imprimir linha horizontal central

     cont2:
        ADD BX, coluna                         ; adiciona 'coluna' (quantidade de elementos da linha) com BX (endeco da linha lida)
        DEC CH                                 ; decrementa CH (contador de linhas)
        JNZ muda_linha                         ; enquanto CH nao for zero, pula para 'muda_linha'

        CALL add_linha2h                       ; chama procedimento 'add_linha2h', para imprimir linha horizontal final

     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
   imprime_mat  ENDP

 ; procedimento para impressao da ultima linha de caracteres ("=") da tabela:
  add_linha2h PROC
     r_push                                    ; chamada macro 'r_push', para salvar conteudos dos registradores
     espaco                                    ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 

     MOV DL, 200                               ; move para DL o caractere 200 (borda esquerda inferior da tabela) 
     INT 21H                                   ; executa funcao, imprimindo o conteudo de DL
     
     MOV CH, coluna                            ; move o conteudo da 'coluna'(9) para o registrador CH (contador)

     repet4:
       MOV CL, 3                               ; move o numero 3 para o registrador CL (contador), pois 1 "numero" do sudoko possui espaco de 3 simbolos "="

     repet3:
       MOV DL, 205                             ; move para DL o caractere 205 (linha de cima da tabela)
       INT 21H                                 ; executa funcao, imprimindo o conteudo de DL

       DEC CL                                  ; decrementa CL (contador de simbulo por "quadrado")
       JNZ repet3                              ; enquanto CH nao for zero, voltar para 'repet3'
     
       CMP CH, 1                               ; compara o conteudo de CH(contador de "quadrados") com 1, para verificar se está sendo impresso o elemento da ultima coluna)
       JE carac_final2                         ; pular para 'carac_final2', se CH for igual a 'coluna', para imprimir o caractere do final da linha

       CMP CH, 7                               ; compara o conteudo de CH(contador de "quadrados") com 7, para verificar se está sendo impresso o elemento da terceira coluna)
       JE dif2                                 ; salta para 'dif2', se CH fro igual a 7
       CMP CH, 4                               ; compara o conteudo de CH(contador de "quadrados") com 4, para verificar se está sendo impresso o elemento da sexta coluna)
       JE dif2                                 ; salta para 'dif2', se CH fro igual a 4
       
       JMP imp2                                ; salta para 'imp2'

     dif2:
       MOV DL, 202                             ; move para DL o caractere 202 (linha da tabela com ligacao para cima)
       
       JMP imp2                                ; pular para 'imp2'

     carac_final2:
       MOV DL, 188                             ; move para DL o caractere 188 (borda direita inferior da tabela)

     imp2:
       INT 21H                                 ; executa funcao, imprimindo o conteudo de DL
       DEC CH                                  ; decrementa CH (contador de "quadrados")
       JNZ repet4                              ; pular para 'repet4', enquanto CH nao for zero

       pula                                    ; chamada macro 'pula', para pular linha entre os caracteres impressos 
     
     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
  add_linha2h ENDP

 ; procedimento para impressao da linha central de caracteres ("=") da tabela:
  add_linha3h PROC
     r_push                                    ; chamada macro 'r_push', para salvar conteudos dos registradores
     espaco                                    ; chama macro 'espaco', para pular um espaco entre os caracteres impressos 

     MOV DL, 204                               ; move para DL o caractere 204 (lateral esquerda meio da tabela) 
     INT 21H                                   ; executa funcao, imprimindo o conteudo de DL
     
     MOV CH, coluna                            ; move o conteudo da 'coluna'(9) para o registrador CH (contador)

     repet6:
       MOV CL, 3                               ; move o numero 3 para o registrador CL (contador), pois 1 "numero" do sudoko possui espaco de 3 simbolos "="

     repet5:
       MOV DL, 205                             ; move para DL o caractere 205 (linha de cima da tabela)
       INT 21H                                 ; executa funcao, imprimindo o conteudo de DL

       DEC CL                                  ; decrementa CL (contador de simbulo por "quadrado")
       JNZ repet5                              ; enquanto CH nao for zero, voltar para 'repet5'
     
       CMP CH, 1                               ; compara o conteudo de CH(contador de "quadrados") com 1, para verificar se está sendo impresso o elemento da ultima coluna)
       JE carac_final3                         ; pular para 'carac_final3', se CH for igual a 'coluna', para imprimir o caractere do final da linha

       CMP CH, 7                               ; compara o conteudo de CH(contador de "quadrados") com 7, para verificar se está sendo impresso o elemento da terceira coluna)
       JE dif3                                 ; salta para 'dif3', se CH fro igual a 7
       CMP CH, 4                               ; compara o conteudo de CH(contador de "quadrados") com 4, para verificar se está sendo impresso o elemento da sexta coluna)
       JE dif3                                 ; salta para 'dif3', se CH fro igual a 4
       
       JMP imp3                                ; salta para 'imp3'

     dif3:
       MOV DL, 206                             ; move para DL o caractere 206 (simbulo meio da tabela com ligacao para todos os lados)
       
       JMP imp3                                ; pular para 'imp3'

     carac_final3:
       MOV DL, 185                             ; move para DL o caractere 185 (lateral direita central da tabela)

     imp3:
       INT 21H                                 ; executa funcao, imprimindo o conteudo de DL
       DEC CH                                  ; decrementa CH (contador de "quadrados")
       JNZ repet6                              ; pular para 'repet6', enquanto CH nao for zero

       pula                                    ; chamada macro 'pula', para pular linha entre os caracteres impressos 

     r_pop                                     ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
  add_linha3h ENDP

 ; procedimento para impressao de mensagem final:
  mens_final PROC
     imp_str denovo                            ; chamada macro 'imp_str', para impressao da mensagem 'denovo' 

     XOR AL, AL                                ; operador XOR entre AL e AL, zerando o registrador AL, para armazenar a resposta do usuario (XOR entre numeros iguais = 0)
     
     faz_leitura                               ; chamada macro 'faz_leitura', para fazer leitura de um caractere 

     RET
  mens_final ENDP

  ; procedimento para impressao de mensagem final:
  mens_final2 PROC
     imp_str denovo2                           ; chamada macro 'imp_str', para impressao da mensagem 'denovo' 

     XOR AL, AL                                ; operador XOR entre AL e AL, zerando o registrador AL, para armazenar a resposta do usuario (XOR entre numeros iguais = 0)
     
     faz_leitura                               ; chamada macro 'faz_leitura', para fazer leitura de um caractere 

     RET
  mens_final2 ENDP
   
 ; procedimento para inserir caractere no jogo2:   
  inserir2 PROC
    r_push                                     ; chamada macro 'r_push', para salvar conteudos dos registradores

    comeco2: 
       imp_str ilinha                          ; chamada macro 'imp_str', para impressao da mensagem 'ilinha'    
       faz_leitura                             ; chamada macro 'faz_leitura', para fazer leitura de um caractere  
       XOR AH, AH                              ; operador XOR entre AH e AH, zerando o registrador AH, para AX possuir so conteudo de AL (XOR entre numeros iguais = 0)
       MOV BX, AX                              ; move conteúdo de AX (numero inserido) para o registrador BX (linha)
       SUB BX, 30h                             ; subtrai o numero hexadecimal 30h do conteudo de BX, obtendo o valor decimal em BX

       imp_str icoluna                         ; chamada macro 'imp_str', para impressao da mensagem 'icoluna'  
       faz_leitura                             ; chamada macro 'faz_leitura', para fazer leitura de um caractere  
       XOR AH, AH                              ; operador XOR entre AH e AH, zerando o registrador AH, para AX possuir so conteudo de AL (XOR entre numeros iguais = 0)
       MOV SI, AX                              ; move conteúdo de AX (numero inserido) para o registrador SI (coluna) 
       SUB SI, 30h                             ; subtrai o numero hexadecimal 30h do conteudo de SI e , obtendo o valor decimal em SI

       imp_str digite                          ; chamada macro 'imp_str', para impressao da mensagem 'digite'
       faz_leitura                             ; chamada macro 'faz_leitura', para fazer leitura de um caractere 
       MOV DH, AL                              ; move conteúdo de AL (numero inserido) para o registrador DH (numero a ser inserido no sudoku) 
       SUB DH, 30h                             ; subtrai o numero hexadecimal 30h do conteudo de DH, obtendo o valor decimal em DH
       
       DEC SI                                  ; decrementa SI (coluna), pois a contagem  de colunas inicializa em 0, nao em 1
       DEC BX                                  ; decrementa BX (linha), pois a contagem  de colunas inicializa em 0, nao em 1
       MOV CH, linha                           ; move o conteudo da 'linha' (9) para o registrador CH (contador de linhas)
       XCHG AX, BX                             ; realiza uma troca (exchange) de conteudo entre os registradores AX (usado na MUL) e BX (linha)       
       MUL CH                                  ; o registrador AX eh o multiplicando e o CH (linha=9) eh o multiplicador
       XCHG AX, BX                             ; realiza uma troca (exchange) de conteudo entre os registradores AX e BX (voltando valores antes da multiplicacao)

       XOR CX, CX                              ; operador XOR entre CX e CX, zerando o registrador CX (XOR entre numeros iguais = 0)

       MOV CH, mat2_pr[BX][SI]                 ; move o conteudo da linha BX e coluna SI da 'mat2_pr' para o registrador CH 
       CMP CH , '_'                            ; compara o conteudo do registrador CH com <anderline> ('_')
       JNE nao2                                ; salta para 'nao2', se CH nao for '_', ou seja, nao eh um espaco livre para receber valor

       
       MOV CH, mat2_sol[BX][SI]                ; move o conteudo da linha BX e coluna SI da 'mat2_sol' para o registrador CH 
       CMP CH, DH                              ; compara o conteudo do registrador CH (resposta correta da posicao) com o de DH (caractere adicionado pelo usuario)
       JZ correto2

       INC erros                               ; incrementa 'erros' (contador de erros)
       CMP erros, 5                            ; compara 'erros' com 5 (numero maximo de erros)
       JE perdeu2                              ; salta para 'perdeu2', se 'erros' for igual a 5

       imp_str erro_comet                      ; chamada macro 'imp_str', para impressao da mensagem 'erro_comet'
       MOV AH, 02                              ; funcao para impressao de caractere
       MOV DL, erros                           ; move o numero de 'erros' cometidos para o registrador DL
       ADD DL, 30h                             ; soma o numero hexadecimal 30h ao conteudo do registrador DL, obtendo o valor decimal em DL
       INT 21H                                 ; executa funcao, imprimindo o conteudo de DL
       imp_str erro                            ; chamada macro 'imp_str', para impressao da mensagem 'erro'

       JMP comeco2                             ; salta para 'comeco2'

     correto2: 
       MOV mat2_pr[BX][SI], DH                 ; move o contudo do registrador DH (numero inserido pelo usuario) para a posicao linha BX e coluna SI da 'mat2_pr' 
       LEA BX, mat2_pr                         ; coloca o endereco da matriz 'mat2_pr' no registrador BX (linhas)
       CALL imprime_mat                        ; chamada procedimento para impressao da matriz -> 'imprime_mat'
       pula                                    ; chamada macro 'pula', para pular linha entre os caracteres impressos
       JMP comeco2                             ; salta para 'comeco2'
       
     nao2:
       imp_str erro1                           ; chamada macro 'imp_str', para impressao da mensagem 'erro1'
       JMP comeco2                             ; salta para 'comeco'
       
     perdeu2: 
       CALL limpa_cor                          ; chamada procedimento para limpar e colorir a tela -> 'limpa_cor'
       imp_str perda                           ; chamada macro 'imp_str', para impressao da mensagem 'perda'

    r_pop                                      ; chamada macro 'r_pop', para restaurar conteudos dos registradores
     RET
  inserir2 ENDP

END main