# NAME
        jogPM - A generic simple password manager

# SYNOPSIS
        jogpm [--help]
        jogpm [setup|gen|save|get] {options}

# USAGE
        help    read the help page (the one that you are currently reading)
        
        setup   setup jogpm on your computer + install jogpm + install jogpm's man page
        
        gen     generte a password
        
                syntax: jogpm gen <password length> <flags>

                must provide at least one flag that isn't --cp

                flags:

                        --char      include english characters
                        --num       include digits
                        --syb       include symbols
                        --sybSpec   include special symbols
                        --cp        copy the generated password
        
        save    save the generated password
                
                syntax: jogpm save <password name> <password>
        
        get     get saved passwords
        
                syntax: jogpm get <password name> <flags>

                flags:

                        --cp        copy the password
