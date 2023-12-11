#!/bin/bash
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}*-------------------*---------------------*${NC}"
echo -e "${YEL}* Protek Recycling - Skip MDM/Create User  *${NC}"
echo -e "${RED}*        Modified by Wilton Ribeiro        *${NC}"
echo -e "${RED}*    Created by SkipMDM.com/Phoenix Team   *${NC}"
echo -e "${CYAN}*-------------------*---------------------*${NC}"
echo ""
PS3='Please enter your choice: '
options=("Autoypass on Recovery" "Reboot")
select opt in "${options[@]}"; do
	case $opt in
	"Autoypass on Recovery")
		echo -e "${GRN}Bypass on Recovery"
		if [ -d "/Volumes/MacHD - Data" ]; then
   			diskutil rename "MacHD - Data" "Data"
   			fi
		echo -e "${GRN}Create a new user "
        echo -e "${BLU}Press Enter to continue, Note: Leaving it blank will create an user automaticly by default named Protek "
  		echo -e "Enter the username (Default: Apple)"
		read realName
  		realName="${realName:= Apple}"
    	echo -e "${BLUE}Username ${RED}WRITE WITHOUT SPACES  ${GRN} (User: Apple)"
      	read username
		username="${username:=Apple}"
  		echo -e "${BLUE}Enter the password (default: 1234) "
    	read passw
      	passw="${passw:=1234}"
		dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default' 
        echo -e "${GREEN}Creating User "
  		# Create user
    	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
      	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	 	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
		mkdir "/Volumes/Data/Users/$username"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
	    dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
	    dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
		echo "0.0.0.0 deviceenrollment.apple.com" >>/Volumes/MacHD/etc/hosts
		echo "0.0.0.0 mdmenrollment.apple.com" >>/Volumes/MacHD/etc/hosts
		echo "0.0.0.0 iprofiles.apple.com" >>/Volumes/MacHD/etc/hosts
        echo -e "${GREEN}Successfully blocked host${NC}"
		# echo "Remove config profile"
		touch /Volumes/Data/private/var/db/.AppleSetupDone
        rm -rf /Volumes/MacHD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	rm -rf /Volumes/MacHD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	touch /Volumes/MacHD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	touch /Volumes/MacHD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
	echo -e "${CYAN}------ Autobypass SUCCESSFULLY - Reboot machine  ------${NC}"
	echo -e "${CYAN}------ Exit Terminal , Reset Macbook and ENJOY ! ------${NC}"
		break
		;;
    "Disable Notification (SIP)")
    	echo -e "${RED}Please Insert Your Password To Proceed${NC}"
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;
    "Disable Notification (Recovery)")
        rm -rf /Volumes/MacHD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	rm -rf /Volumes/MacHD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	touch /Volumes/MacHD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	touch /Volumes/MacHD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

        break
        ;;
	"Check MDM Enrollment")
		echo ""
		echo -e "${GRN}Check MDM Enrollment. Error is success${NC}"
		echo ""
		echo -e "${RED}Please Insert Your Password To Proceed${NC}"
		echo ""
		sudo profiles show -type enrollment
		break
		;;
		"Exit")
 		echo "Rebooting..."
		reboot
		break
		;;
	*) echo "Invalid option $REPLY" ;;
	esac
done
