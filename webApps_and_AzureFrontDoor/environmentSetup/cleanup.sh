read -p "This will delete your test envrionment enter Y to confirm " yn
    case $yn in
        [Yy] ) az group delete --no-wait --name rgDemoPrimaryRegion; az group delete --no-wait --name rgDemoSecondaryRegion; echo "Resource Group deletion initiated"; break;;
        *) echo "Cancelled";;
    esac