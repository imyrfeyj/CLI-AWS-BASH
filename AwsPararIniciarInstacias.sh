#!/bin/bash

#########################################################################
# 									#
# PararIniciarTodos.sh - inicia ou para todas as instancia da aws       #
#									#
# Autor: Mauricio Grillo de Moura (https://github.com/imyrfeyj)  	#
# Data Criação: 29/05/2018						#
#									#
# Descrição: Script inicia ou para todas as instancias de uma conta AWS #
#	     que estejam em um estado, este .SH permite que o usuario   #
#            escolha o estado das instancias que serão afetadas.        #
#	    				 				#
# Exemplo de uso: ./ParaIniciarTodos                                    #
#                                                                       #
# Observações: todas as perguntas devem ser respondidas em letras       #
#	       minusculas 				        	#
#									#
#########################################################################

#Variaveis 

PATHD=/home/mauricio/script-aws/.rinstance.txt

read -p "Informe o status das instacias afetadas entre: pending | running | shutting-down | stopping | stopped " STATUS

read -p "Qual a ação deverá ser realizada, start ou stop? " ACAO

#-------------------------------------------------------------------


# Salva em um arquivo as instacias com o estado escolhido

aws ec2 describe-instances --filters "Name=instance-state-name,Values=$STATUS" | grep InstanceId | tr -d ' ''"',| cut -d ':' -f2| tr "\n" " " > $PATHD

#---------------------------------------------------------------------

# para ou inicia a instacia, respeitando a ação escolhida na variavel ACAO

case $ACAO in 
	stop)
	for count in $(cat $PATHD)
	do
		echo "Parando instacia: $count" 
		aws ec2 stop-instances --instance-ids $count
	done
	;;
 
 
	start)
	for count in $(cat $PATHD)
	do
		echo "Iniciando instancia: $count" 
		aws ec2 start-instances --instance-ids $count
	done
	;;
esac
