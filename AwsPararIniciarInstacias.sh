#!/bin/bash

#########################################################################
# 								                                        #
# PararIniciarTodos.sh - inicia ou para todas as instancia da aws       #
# Autor: Mauricio Grillo de Moura (https://github.com/imyrfeyj)         #
# Data Criação: 29/05/2018					                            #
# Descrição: Script inicia ou para todas as instancias de uma conta AWS #
#	    	 que estejam em um estado, este .SH permite que o usuario   #   
#            escolha o estado das instancias que serão afetadas.        #
# Exemplo de uso: ./ParaIniciarTodos                                    #
#########################################################################

 # Caminho do arquivo auxiliar

PATHD=/home/mauricio/script-aws/.rinstance.txt

#-----------------------------------------------------------

#Variaveis 

read -p "Informe o status das instacias afetadas entre: pending | running | shutting-down | stopping | stopped " STATUS

read -p "Qual a ação deverá ser realizada, start ou stop? " ACAO

#-------------------------------------------------------------------

#Trata inserção case-sensitive das variaveis

STATUS=$(echo $STATUS | tr 'A-Z' 'a-z')
ACAO=$(echo $ACAO | tr 'A-Z' 'a-z')

#-------------------------------------------------------------------


# Salva em um arquivo as instacias com o estado escolhido

aws ec2 describe-instances --filters "Name=instance-state-name,Values=$STATUS" | grep InstanceId | tr -d ' ''"',| cut -d ':' -f2| tr "\n" " " > $PATHD

#---------------------------------------------------------------------

# para ou inicia a instacia, respeitando a ação escolhida na variavel ACAO

case $ACAO in 
	stop)
	for ID in $(cat $PATHD)
	do
		echo "Parando instacia: $ID" 
		aws ec2 stop-instances --instance-ids $ID
	done
	;;
 
 
	start)
	for ID in $(cat $PATHD)
	do
		echo "Iniciando instancia: $ID" 
		aws ec2 start-instances --instance-ids $ID
	done
	;;
esac
# teste
