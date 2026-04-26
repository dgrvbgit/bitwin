function abrirVentana(id) {
    document.getElementById(id).classList.add('abierto');
}

function cerrarVentana(id) {
    document.getElementById(id).classList.remove('abierto');
    document.getElementById(id === 'ventana-registro' ? 'msg-registro' : 'msg-login').textContent = '';
}

function switchVentana(cerrar, abrir) {
    cerrarVentana(cerrar);
    abrirVentana(abrir);
}

function bajarPagina() {
    window.scrollBy({ top: window.innerHeight, behavior: 'smooth' });
}

// Para cerrar la ventana
document.querySelectorAll('.ventana-fondo').forEach(function(fondo) {
    fondo.addEventListener('click', function(e) {
        if (e.target === fondo) {
            fondo.classList.remove('abierto');
        }
    });
});

// Formulario 
document.getElementById('form-registro').addEventListener('submit', async function(e) {
    e.preventDefault();
    var msg = document.getElementById('msg-registro');
    msg.className = 'mensaje-form';
    msg.textContent = '';

    var datos = {
        username: document.getElementById('reg-username').value.trim(),
        email: document.getElementById('reg-email').value.trim(),
        password: document.getElementById('reg-password').value
    };

    try {
        var res = await fetch('api/auth/register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(datos)
        });
        var json = await res.json();

        if (res.ok) {
            msg.textContent = 'Cuenta creada. Ahora puedes iniciar sesion.';
            document.getElementById('form-registro').reset();
        } else {
            msg.classList.add('error');
            msg.textContent = json.error || 'Error al registrarse.';
        }
    } catch (err) {
        msg.classList.add('error');
        msg.textContent = 'No se pudo conectar con el servidor.';
    }
});

//Login
document.getElementById('form-login').addEventListener('submit', async function(e) {
    e.preventDefault();
    var msg = document.getElementById('msg-login');
    msg.className = 'mensaje-form';
    msg.textContent = '';

    var datos = {
        email: document.getElementById('login-email').value.trim(),
        password: document.getElementById('login-password').value
    };

    try {
        var res = await fetch('api/auth/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(datos)
        });
        var json = await res.json();

        if (res.ok) {
            msg.textContent = 'Bienvenido, ' + json.usuario.username + '!';
            // Aqui cuando este lista la sala pues redirijo con window.location.href = 'sala.html';
        } else {
            msg.classList.add('error');
            msg.textContent = json.error || 'Email o contrasena incorrectos.';
        }
    } catch (err) {
        msg.classList.add('error');
        msg.textContent = 'No se pudo conectar con el servidor.';
    }
});
