# Sincronización Inteligente con Caché

## Problema Resuelto

**Antes:** Cada vez que se abría Home, se sincronizaban TODAS las APIs (60+ segundos)
**Ahora:** Solo sincroniza cuando es necesario (< 1 segundo en 90% de los casos)

## Cómo Funciona

### Nueva Acción: `cargarDatosConCacheInteligente`

Esta acción reemplaza a `cargarTodosLosDatosUsuario` en el Home y decide automáticamente qué tipo de sincronización hacer.

## Tipos de Sincronización

### 1️⃣ Sincronización COMPLETA (APIs + Supabase)
**Tiempo:** ~60 segundos
**Cuándo:**
- ✅ Usuario tiene `role = 'usuario'` en tabla Users
- ✅ Primera vez (SQLite vacío - sin datos)
- ✅ Botón manual "Sincronizar" (`forceFullSync: true`)

**Qué hace:**
1. Verifica rol del usuario en tabla Users
2. Si `role != 'usuario'` → Carga rápida (sin APIs)
3. Si `role = 'usuario'` → Llama APIs de HighBond + Supabase
4. Combina ambos y guarda en SQLite
5. Actualiza timestamp de última sync completa

### 2️⃣ Sincronización RÁPIDA (Solo SQLite + Supabase)
**Tiempo:** < 1 segundo
**Cuándo:**
- ✅ Ya tiene datos en SQLite/AppState
- ✅ NO es forzada manualmente

**Qué hace:**
1. Carga datos desde SQLite (instantáneo)
2. Valida cambios con Supabase (solo photos, completed, etc.)
3. Actualiza solo lo que cambió
4. NO llama APIs de HighBond

## Uso

### En Home (Automático)

```dart
// Reemplazar esto:
await cargarTodosLosDatosUsuario(userId);

// Por esto:
await cargarDatosConCacheInteligente(userId);
```

### En Botón "Sincronizar" (Manual)

```dart
// Forzar sincronización completa
await cargarDatosConCacheInteligente(
  userId,
  forceFullSync: true,
);
```

## Parámetros

### `userId` (String, required)
El UUID del usuario actual desde autenticación

### `forceFullSync` (bool, opcional, default: false)
- `false`: Sincronización inteligente (automática)
- `true`: Fuerza sincronización completa con APIs (botón manual)

## Ejemplos de Uso

### Ejemplo 1: Home - Carga Automática
```dart
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final userId = currentUserUid;

    // Sincronización inteligente
    await cargarDatosConCacheInteligente(userId);
  });
}
```

### Ejemplo 2: Botón Sincronizar - Forzar Sync Completa
```dart
ElevatedButton(
  onPressed: () async {
    final userId = currentUserUid;

    // Mostrar loading
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Sincronizando...'),
      ),
    );

    // Forzar sync completa
    await cargarDatosConCacheInteligente(
      userId,
      forceFullSync: true,
    );

    // Cerrar loading
    Navigator.pop(context);

    // Mostrar mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sincronización completada')),
    );
  },
  child: Text('Sincronizar'),
)
```

### Ejemplo 3: Verificar Si Necesita Sync
```dart
// Si quieres saber qué tipo de sync se hará
final prefs = await SharedPreferences.getInstance();
final lastSync = prefs.getInt('last_full_sync_$userId') ?? 0;
final ahora = DateTime.now().millisecondsSinceEpoch;
final horas = (ahora - lastSync) / (1000 * 60 * 60);

if (horas >= 8) {
  print('Se hará sync completa (> 8 horas)');
} else {
  print('Se hará sync rápida (< 8 horas)');
}
```

## Logs

La función imprime logs detallados para debugging:

### Usuario con role = 'usuario' (puede usar APIs)
```
🚀 ===== CARGA INTELIGENTE DE DATOS =====
👤 Usuario UUID: 840607b0-1427-44b4-9db4-450cd5458f72

🔐 Verificando rol de usuario...
👤 Rol del usuario: usuario
✅ Usuario con rol "usuario" - puede sincronizar con APIs
⏰ Última sync completa: 2.3 horas atrás
📊 Estado actual:
  - Tiene objetivos en AppState: true
  - Tiene controles en AppState: true
  - Forzar sync completa: false

⚡ CARGA RÁPIDA (SQLite + Supabase)
   - NO llamar APIs de HighBond
   - SÍ validar cambios en Supabase

1️⃣ Cargando desde SQLite (instantáneo)...
✅ Datos cargados desde caché
   - Objetivos: 4
   - Controles: 50

2️⃣ Validando cambios con Supabase...
📋 Proyectos encontrados: 4
✅ Sincronización con Supabase completada
   Objetivos procesados: 4

✅ Carga inteligente completada
```

### Usuario con otro role (admin, supervisor, etc.)
```
🚀 ===== CARGA INTELIGENTE DE DATOS =====
👤 Usuario UUID: 840607b0-1427-44b4-9db4-450cd5458f72

🔐 Verificando rol de usuario...
👤 Rol del usuario: admin
⚠️ Rol "admin" no tiene acceso a sincronización completa
   Solo se cargará desde SQLite/Supabase (sin APIs de HighBond)

⚡ CARGA RÁPIDA (SQLite + Supabase)
1️⃣ Cargando desde SQLite (instantáneo)...
✅ Datos cargados desde caché
   - Objetivos: 4
   - Controles: 50

2️⃣ Validando cambios con Supabase...
✅ Sincronización con Supabase completada

✅ Carga rápida completada
```

## Ventajas

| Aspecto | Antes | Ahora |
|---------|-------|-------|
| **Tiempo primera vez** | 60s | 60s (igual) |
| **Tiempo aperturas posteriores** | 60s | < 1s ⚡ |
| **Llamadas a APIs** | Siempre | Solo cada 8h |
| **Consumo de datos** | Alto | Bajo |
| **Experiencia usuario** | Lenta | Rápida |

## Configuración

La sincronización completa SOLO se ejecuta si se cumplen TODAS estas condiciones:

```dart
// 1. Usuario debe tener role = 'usuario'
final userRole = usuarioData.first.role ?? '';
final puedeUsarAPIs = userRole.toLowerCase() == 'usuario';

// 2. Es primera vez O forzado manualmente
final necesitaSyncCompleta = !tieneDatos || forceFullSync;
```

### Condiciones:
1. ✅ **Role = 'usuario'** en tabla Users (REQUERIDO)
2. ✅ **Primera vez** (SQLite vacío) O **Botón manual** (forceFullSync)

### Otros roles (admin, supervisor, etc.):
- ❌ **NO pueden** hacer sync completa con APIs
- ✅ **Solo** cargan desde SQLite + Supabase (carga rápida)
- ⚡ Siempre < 1 segundo

**NO hay expiración de caché automática.** El usuario controla cuándo sincronizar completamente con el botón manual.

## Almacenamiento del Timestamp

El timestamp de la última sync completa se guarda en SharedPreferences:

```dart
final cacheKey = 'last_full_sync_$userId';
await prefs.setInt(cacheKey, DateTime.now().millisecondsSinceEpoch);
```

Cada usuario tiene su propio timestamp de caché.

## Migración

Para migrar tu código actual:

1. **Buscar:**
   ```dart
   await cargarTodosLosDatosUsuario(userId);
   ```

2. **Reemplazar por:**
   ```dart
   await cargarDatosConCacheInteligente(userId);
   ```

3. **Para botones manuales:**
   ```dart
   await cargarDatosConCacheInteligente(userId, forceFullSync: true);
   ```

## Testing

### Probar Primera Vez
```dart
// Limpiar caché
final prefs = await SharedPreferences.getInstance();
await prefs.remove('last_full_sync_$userId');
FFAppState().jsonControles = [];
FFAppState().jsonObjetivos = [];

// Ejecutar
await cargarDatosConCacheInteligente(userId);
// Debería hacer sync completa (60s)
```

### Probar Carga Rápida
```dart
// Asegurarse de que tiene datos
print(FFAppState().jsonControles.length); // > 0
print(FFAppState().jsonObjetivos.length); // > 0

// Ejecutar
await cargarDatosConCacheInteligente(userId);
// Debería hacer sync rápida (< 1s)
```

### Probar Botón Manual
```dart
// Aunque tenga datos, debería forzar sync completa
print(FFAppState().jsonControles.length); // > 0

// Ejecutar con forzado
await cargarDatosConCacheInteligente(userId, forceFullSync: true);
// Debería hacer sync completa (60s)
```

## Notas Importantes

⚠️ **La función `cargarTodosLosDatosUsuario` sigue existiendo** y es llamada internamente cuando se necesita sync completa.

⚠️ **Supabase siempre se valida** incluso en carga rápida, para mantener photos/videos/completed actualizados.

✅ **No rompe nada existente** - es backward compatible.

✅ **No requiere cambios en UI** - solo reemplazar la llamada a la acción.
