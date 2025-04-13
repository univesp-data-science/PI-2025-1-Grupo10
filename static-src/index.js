
// pegar o valor do email
// verificar se o email não é vazio e se oemailé válido
// se verdadeiro, então habilitar o botão de recuperar senha
//se falso, então habilitar o botão de recuperar senha
function validateFilds(){
    const emailValid= isEmailValid();
    document.getElementById("recover-password-button").disable = !emailValid;
    
    const passwordValid = isPassWordValid();
    document.getElementById("login-button").disable = !emailValid || !passwordValid;
    }
function isEmailValid(){
    const email = document.getElementById("email").value;
    if (!email) {
        return false;
    }
    return validateEmail(email);
}  
function isPassWordValid(){
    const password = document.getElementById("password").value;
    if (!password) {
        return false;
    }
    return true;
}

function validateEmail(email){
    return /\S+@\S+\.\S+/.test(email);
}





//https://gofurthergroup.com.br/wp-content/uploads/2023/03/wifi.png