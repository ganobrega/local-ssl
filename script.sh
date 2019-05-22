#! /bin/sh
NAME='myCA'
DOMAIN='dev.localhost.com'

echo "Iniciando Local SSL"
read -p "Pressione a tecla Y para iniciar os passos: " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

openssl genrsa -des3 -out $NAME.key 2048
openssl req -x509 -new -nodes -key $NAME.key -sha256 -days 1825 -out $FILENAME.pem


echo "Abrindo aplicativo 'Keychan Access.app'..."

open /Applications/Utilities/Keychain\ Access.app

echo "Siga os passos abaixo, dentro do aplicativo 'Chaves':"
echo "1.Abra o menu em Arquivo > Importar Itens…"
echo "2.Busque pelo nome do 'Common Name' inserido no formulário"
echo "3.Clique duas vezes no certificado"
echo "4.Abra o leque 'Confiar'"
echo "5.Mude o primeiro item para: Sempre Confiar"
echo "6.Feche a janela"
echo "7.Feche o aplicativo"



read -p "Pressione a tecla Y se você finalizou a etapa acima: " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi


openssl genrsa -out $DOMAIN.key 2048
openssl req -new -key $DOMAIN.key -out $DOMAIN.csr

echo "authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DOMAIN" > $DOMAIN.ext

openssl x509 -req -in $DOMAIN.csr -CA $NAME.pem -CAkey $NAME.key -CAcreateserial -out $DOMAIN.crt -days 1825 -sha256 -extfile $DOMAIN.ext
