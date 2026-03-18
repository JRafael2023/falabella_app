# Solución: Row too big to fit into CursorWindow

## Problema
SQLite tiene un límite de 2MB por fila. Cuando un control tiene muchas imágenes, videos o archivos en Base64, el tamaño de la fila excede este límite y genera el error:
```
DatabaseException: Row too big to fit into CursorWindow
```

## Solución Implementada
Creamos una tabla separada `ControlAttachments` para almacenar los archivos adjuntos (photos, videos, archives) fuera de la tabla principal `Controles`.

### Cambios Realizados

#### 1. Base de Datos (sqlite_helper.dart)
- **Versión actualizada**: 14 → 15
- **Nueva tabla**: `ControlAttachments`
  ```sql
  CREATE TABLE ControlAttachments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_control TEXT NOT NULL,
    attachment_type TEXT NOT NULL,      -- 'photo', 'video', 'archive'
    attachment_data TEXT NOT NULL,      -- Base64 data
    attachment_index INTEGER NOT NULL,  -- Orden (0, 1, 2, ...)
    created_at TEXT,
    UNIQUE(id_control, attachment_type, attachment_index)
  )
  ```

- **Migración automática**:
  - Al actualizar de v14 a v15, todos los attachments existentes en la tabla `Controles` se migran automáticamente a la nueva tabla `ControlAttachments`
  - Los campos `photos`, `video`, `archives` en la tabla `Controles` se limpian (vacíos)

#### 2. Nuevo Helper (DBControlAttachments.dart)
Clase helper para gestionar los attachments en la tabla separada:

**Métodos principales**:
- `guardarPhotos(idControl, List<String> photos)` - Guardar múltiples fotos
- `guardarVideo(idControl, String video)` - Guardar video
- `guardarArchives(idControl, List<String> archives)` - Guardar múltiples archivos
- `obtenerPhotos(idControl)` → `List<String>` - Obtener fotos
- `obtenerVideo(idControl)` → `String?` - Obtener video
- `obtenerArchives(idControl)` → `List<String>` - Obtener archivos
- `contarPhotos(idControl)` → `int` - Contar fotos
- `contarArchives(idControl)` → `int` - Contar archivos
- `tieneVideo(idControl)` → `bool` - Verificar si tiene video
- `eliminarTodosAttachments(idControl)` - Eliminar todos los attachments de un control

#### 3. Actualización DBControles.dart
Modificado para usar la tabla de attachments:

**insertControl()**:
- Extrae photos, videos, archives del Control
- Limpia esos campos antes de insertar en tabla Controles
- Guarda los attachments en tabla separada

**updateControl()**:
- Extrae photos, videos, archives del Control
- Limpia esos campos antes de actualizar en tabla Controles
- Actualiza los attachments en tabla separada

**obtenerControlCompleto()**:
- Obtiene el control desde tabla Controles
- Obtiene los attachments desde tabla ControlAttachments
- Combina ambos y retorna el control completo

**listarControlesJson()**:
- Ahora incluye contadores: `photos_count`, `archives_count`, `has_video`
- Estos contadores se pueden usar en la UI para mostrar "3 fotos", "1 video", etc.
- NO carga los datos Base64 completos (solo contadores)

**insertControlesMasivos()**:
- Elimina attachments existentes antes de insertar nuevos
- Separa los attachments y los guarda en tabla separada

## Ventajas de esta Solución

1. **Sin límite de 2MB**: Cada attachment está en su propia fila
2. **Mejor rendimiento**:
   - Listar controles es mucho más rápido (no carga Base64)
   - Solo se cargan attachments cuando se abre un control específico
3. **Escalable**: Soporta cientos de imágenes por control sin problemas
4. **Contadores eficientes**: La UI puede mostrar "5 fotos" sin cargar el Base64
5. **Migración automática**: Los datos existentes se migran sin perder información

## Cómo Usar

### Guardar un control con attachments
```dart
Control control = Control(
  idControl: 'ctrl_123',
  title: 'Control ejemplo',
  // ... otros campos
);

// Agregar fotos
control.addPhoto(base64Photo1);
control.addPhoto(base64Photo2);
control.addPhoto(base64Photo3);

// Agregar video
control.addVideo(base64Video);

// Agregar archivos
control.addArchive(base64File1);

// Guardar (automáticamente separa los attachments)
await DBControles.insertControl(control);
```

### Listar controles (solo datos mínimos + contadores)
```dart
// Obtiene lista sin cargar Base64 completo
final controles = await DBControles.listarControlesJson(idObjetivo);

// Cada control tendrá:
// - photos_count: 3
// - archives_count: 1
// - has_video: 1
// - photos: null (no carga Base64 aquí)
```

### Obtener control completo (cuando se abre)
```dart
// Carga todo incluyendo Base64 de attachments
final controlCompleto = await DBControles.obtenerControlCompleto(idControl);

// Ahora tiene:
// - photos: "base64_1,base64_2,base64_3"
// - video: "base64_video"
// - archives: "base64_file1,base64_file2"
```

## Testing

Para probar que funciona correctamente:

1. **Probar migración**:
   - Si ya tienes datos en v14, al abrir la app se migrará a v15 automáticamente
   - Verifica en logs: "✅ Migrados X attachments a la nueva tabla"

2. **Probar inserción con muchas imágenes**:
   - Crea un control con 20+ imágenes
   - Verifica que se guarda sin error "Row too big"

3. **Probar carga de lista**:
   - Lista controles debe ser rápida
   - Debe mostrar contadores correctos

4. **Probar carga individual**:
   - Abrir un control debe cargar todos los attachments
   - Verificar que se muestran correctamente

## Notas Importantes

- ⚠️ Los campos `photos`, `video`, `archives` en la tabla `Controles` ahora están VACÍOS (migrados a ControlAttachments)
- ⚠️ `listarControlesJson()` ahora retorna `photos: null`, `video: null`, `archives: null` (usa contadores en su lugar)
- ⚠️ Solo `obtenerControlCompleto()` carga los datos Base64 completos
- ✅ La migración es automática y no requiere intervención manual
- ✅ No se pierde ningún dato durante la migración
- ✅ Soporta ilimitadas imágenes por control

## Archivos Modificados

1. `lib/custom_code/sqlite_helper.dart` - Añadida tabla y migración v15
2. `lib/custom_code/DBControlAttachments.dart` - Nuevo helper para attachments
3. `lib/custom_code/DBControles.dart` - Actualizado para usar tabla separada
