import 'dart:convert';
import 'package:tottus/custom_code/proceso.dart';

class Titulo {
  int? id;
  Proceso process;
  String name;

  Titulo({
    this.id,
    required this.name,
    required this.process,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'process_id': process.id,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'process': process.toJson(),
    };
  }

  factory Titulo.fromJson(Map<String, dynamic> json) {
    return Titulo(
      id: json['id'],
      name: json['name'],
      process: Proceso.fromJson(json['process']),
    );
  }

  factory Titulo.fromMap(Map<String, dynamic> m) => Titulo(
        id: m['id'] as int?,
        name: m['name'] as String,
        process: m['process'] as Proceso,
      );

  static Future<List<Map<String, dynamic>>> getAllTitulosProcesos() async {
    final Proceso procesoSeguridad = Proceso(
      id: 1,
      name: "Seguridad Física",
      abbreviation: "SF",
    );

    final Proceso procesoCalidad = Proceso(
      id: 2,
      name: "Calidad",
      abbreviation: "CA",
    );

    final Proceso procesoCumplimiento = Proceso(
      id: 3,
      name: "Cumplimiento Normativo",
      abbreviation: "CN",
    );

    final Proceso procesoOperaciones = Proceso(
      id: 4,
      name: "Operaciones",
      abbreviation: "OP",
    );

    List<Titulo> titulos = [
      Titulo(
          id: 1,
          name:
              "Ambientes de la tienda no cuentan con detector de humo o presenta fallas en su operación.",
          process: procesoSeguridad),
      Titulo(
          id: 2,
          name:
              "Ausencia u otras situaciones identificadas relacionadas con extintores de acetato de potasio (grasas).",
          process: procesoSeguridad),
      Titulo(
          id: 3,
          name:
              "Colaborador(es) no usa(n) equipos de protección personal (EPP).",
          process: procesoSeguridad),
      Titulo(
          id: 4,
          name: "Acumulación de escarcha en la cámara de congelados.",
          process: procesoSeguridad),
      Titulo(
          id: 5,
          name:
              "Condiciones de riesgo eléctrico en tableros eléctricos, dispositivos eléctricos y otros.",
          process: procesoSeguridad),
      Titulo(
          id: 6,
          name:
              "Fallos en la operación de puertas de emergencia y/o falta de alerta al panel de intrusión.",
          process: procesoSeguridad),
      Titulo(
          id: 7,
          name: "Fallos en sistema CCTV y/o situaciones no reportadas al COE.",
          process: procesoSeguridad),
      Titulo(
          id: 8,
          name: "Inadecuado almacenamiento de balones GLP.",
          process: procesoSeguridad),
      Titulo(
          id: 9,
          name:
              "Inadecuado almacenamiento y estado de conservación de extintores.",
          process: procesoSeguridad),
      Titulo(
          id: 10,
          name:
              "Incumplimiento de medidas de seguridad para almacenamiento de mercadería en bodega.",
          process: procesoSeguridad),
      Titulo(
          id: 11,
          name:
              "Incumplimiento de medidas de seguridad para exhibición y/o almacenamiento de mercadería en piso de venta.",
          process: procesoSeguridad),
      Titulo(
          id: 12,
          name: "Miembros de Brigada no cuentan con capacitación.",
          process: procesoSeguridad),
      Titulo(
          id: 13,
          name:
              "Pallets sin vitafilm desde la base y/o altura de éstos no cumplen estándares de almacenamiento.",
          process: procesoSeguridad),
      Titulo(
          id: 14,
          name:
              "Pruebas de activación del gabinete de LCI no se ejecutaron correctamente.",
          process: procesoSeguridad),
      Titulo(
          id: 15,
          name:
              "Pruebas de apertura de puertas de emergencia no se ejecutaron correctamente.",
          process: procesoSeguridad),
      Titulo(
          id: 16,
          name:
              "Riesgo de incendio por grasa acumulada en campanas, trampas de grasa y/u otras zonas de la tienda.",
          process: procesoSeguridad),
      Titulo(
          id: 17,
          name:
              "Temperatura en el gabinete principal de sistemas no cumple estándares.",
          process: procesoSeguridad),
      Titulo(
          id: 18,
          name:
              "Uso de apilador por parte de colaboradores sin evidencia de capacitación o que no están autorizados.",
          process: procesoSeguridad),
      Titulo(
          id: 19,
          name:
              "Uso de extensión eléctrica, adaptadores y/o dispositivos eléctricos no autorizados en los estándares.",
          process: procesoSeguridad),
      Titulo(
          id: 20,
          name: "Rutas de evacuación obstaculizadas total o parcialmente.",
          process: procesoSeguridad),
      Titulo(
          id: 21,
          name:
              "Válvulas de corte del Sistema LCI (Manifold) no emiten alerta en panel y/o no operan adecuadamente.",
          process: procesoSeguridad),
      Titulo(
          id: 22,
          name: "Puenteo de interruptores diferenciales.",
          process: procesoSeguridad),
      Titulo(
          id: 23,
          name:
              "Panel de Lucha Contra Incendio (LCI) presenta falsa(s) alerta(s).",
          process: procesoSeguridad),
      Titulo(
          id: 24,
          name: "Falla o ausencia del sistema puesta tierra en equipos.",
          process: procesoSeguridad),
      Titulo(
          id: 25,
          name: "Condiciones inseguras en ambientes o zonas de la tienda.",
          process: procesoSeguridad),
      Titulo(
          id: 26,
          name: "Pruebas y/o inspecciones no se ejecutaron correctamente.",
          process: procesoSeguridad),

      Titulo(
          id: 27,
          name:
              "Condiciones de limpieza en piso de venta, trastienda y/u otras zonas de la tienda no cumplen estándares.",
          process: procesoCalidad),
      Titulo(
          id: 28,
          name:
              "Condiciones organolépticas de productos no cumplen estándares para la venta.",
          process: procesoCalidad),
      Titulo(
          id: 29,
          name: "Incumplimiento de condiciones de refrigeración de mercadería.",
          process: procesoCalidad),
      Titulo(
          id: 30,
          name: "Presencia de óxido en equipos o instalaciones en tienda.",
          process: procesoCalidad),
      Titulo(
          id: 31,
          name: "Presencia de vectores en piso de venta y/o trastienda.",
          process: procesoCalidad),
      Titulo(
          id: 32,
          name:
              "Productos exhibidos en sala de ventas sin fecha de vencimiento.",
          process: procesoCalidad),
      Titulo(
          id: 33,
          name: "Productos no retirados oportunamente.",
          process: procesoCalidad),
      Titulo(
          id: 34,
          name: "Productos vencidos en piso de venta.",
          process: procesoCalidad),
      Titulo(
          id: 35,
          name:
              "Cámara de frío / Walk in freezer no cumple con estándares de conservación.",
          process: procesoCalidad),
      Titulo(
          id: 36,
          name:
              "Falla o falta de mantenimiento en los dispositivos de control de vectores y plagas.",
          process: procesoCalidad),
      Titulo(
          id: 37,
          name: "Manipulación inadecuada de productos perecibles.",
          process: procesoCalidad),

      Titulo(
          id: 38,
          name:
              "Certificado de limpieza y desinfección de cisternas de agua potable y LCI vencido.",
          process: procesoCumplimiento),
      Titulo(
          id: 39,
          name: "Falta o errores en el registro de entrega de EPPs.",
          process: procesoCumplimiento),
      Titulo(
          id: 40,
          name:
              "Layout de sala de venta, trastienda y otras zonas de la tienda no coincide con plano de arquitectura.",
          process: procesoCumplimiento),
      Titulo(
          id: 41,
          name: "Falta de publicación de letreros normativos.",
          process: procesoCumplimiento),
      Titulo(
          id: 42,
          name:
              "Locatarios: Licencia de funcionamiento, Certificado ITSE, Uso indebido de espacios.",
          process: procesoCumplimiento),

      Titulo(
          id: 43,
          name:
              "Errores o incumplimiento del procedimiento sobre arqueos inopinados del fondo de las cajas registradoras.",
          process: procesoOperaciones),
      Titulo(
          id: 44,
          name:
              "Ausencia o falla en la operación del botón de pánico en Tesorería o no emite alerta a G4S/Prosegur.",
          process: procesoOperaciones),
      Titulo(
          id: 45,
          name:
              "Falta de control en gestión de accesos a paneles biométricos y/o caja fuerte o bóveda de Tesorería.",
          process: procesoOperaciones),
      Titulo(
          id: 46,
          name:
              "Incumplimiento de lineamientos sobre la entrega y uso del fondo de para cambio de sencillo.",
          process: procesoOperaciones),
      Titulo(
          id: 47,
          name:
              "Incumplimiento en la ejecución de los arqueos del fondo de bóveda.",
          process: procesoOperaciones),
      Titulo(
          id: 48,
          name: "Incumplimiento en la administración del fondo fijo de bóveda.",
          process: procesoOperaciones),
      Titulo(
          id: 49,
          name: "Incumplimiento del procedimiento de pick up.",
          process: procesoOperaciones),
      Titulo(
          id: 50,
          name: "Controles declarados no ejecutados.",
          process: procesoOperaciones),
      Titulo(
          id: 51,
          name: "Trabajos de mantenimiento crìticos pendientes de reportar.",
          process: procesoOperaciones),
      Titulo(
          id: 52,
          name: "Incumplimiento de procesos de Clase 100.",
          process: procesoOperaciones),
      Titulo(
          id: 53,
          name:
              "Notas de crédito sin firma de Supervisor o incumplen procedimientos.",
          process: procesoOperaciones),
      Titulo(
          id: 54,
          name:
              "Niveles no aceptados de pruebas físico-químicas de aceite dieléctrico.",
          process: procesoOperaciones),
      Titulo(
          id: 55,
          name:
              "Problemas con equipos de aire acondicionado, UPS y otros similares.",
          process: procesoOperaciones),
      Titulo(
          id: 56,
          name: "Notas de Crédito no cuentan con VoBo de Gerente de Tienda.",
          process: procesoOperaciones),
      Titulo(
          id: 57,
          name:
              "Filtraciones o presencia de humedad en sala de ventas, trastienda o ambientes críticos.",
          process: procesoOperaciones),
      Titulo(
          id: 58,
          name:
              "Dispositivo(s) de detección no emite(n) alerta en el panel de LCI y/o no opera(n) adecuadamente.",
          process: procesoOperaciones),
      Titulo(
          id: 59,
          name:
              "Trabajos de mantenimiento preventivo no programados en el cronograma anual.",
          process: procesoOperaciones),
    ];

    List<Map<String, dynamic>> jsonTitulos =
        titulos.map((title) => title.toJson()).toList();

    return jsonTitulos;
  }

  static Future<List<Titulo>> getAllTitulosProcesosStatic() async {
    final Proceso procesoSeguridad = Proceso(
      id: 1,
      name: "Seguridad Física",
      abbreviation: "SF",
    );

    final Proceso procesoCalidad = Proceso(
      id: 2,
      name: "Calidad",
      abbreviation: "CA",
    );

    final Proceso procesoCumplimiento = Proceso(
      id: 3,
      name: "Cumplimiento Normativo",
      abbreviation: "CN",
    );

    final Proceso procesoOperaciones = Proceso(
      id: 4,
      name: "Operaciones",
      abbreviation: "OP",
    );

    List<Titulo> titulos = [
      Titulo(
          id: 1,
          name:
              "Ambientes de la tienda no cuentan con detector de humo o presenta fallas en su operación.",
          process: procesoSeguridad),
      Titulo(
          id: 2,
          name:
              "Ausencia u otras situaciones identificadas relacionadas con extintores de acetato de potasio (grasas).",
          process: procesoSeguridad),
      Titulo(
          id: 3,
          name:
              "Colaborador(es) no usa(n) equipos de protección personal (EPP).",
          process: procesoSeguridad),
      Titulo(
          id: 4,
          name: "Acumulación de escarcha en la cámara de congelados.",
          process: procesoSeguridad),
      Titulo(
          id: 5,
          name:
              "Condiciones de riesgo eléctrico en tableros eléctricos, dispositivos eléctricos y otros.",
          process: procesoSeguridad),
      Titulo(
          id: 6,
          name:
              "Fallos en la operación de puertas de emergencia y/o falta de alerta al panel de intrusión.",
          process: procesoSeguridad),
      Titulo(
          id: 7,
          name: "Fallos en sistema CCTV y/o situaciones no reportadas al COE.",
          process: procesoSeguridad),
      Titulo(
          id: 8,
          name: "Inadecuado almacenamiento de balones GLP.",
          process: procesoSeguridad),
      Titulo(
          id: 9,
          name:
              "Inadecuado almacenamiento y estado de conservación de extintores.",
          process: procesoSeguridad),
      Titulo(
          id: 10,
          name:
              "Incumplimiento de medidas de seguridad para almacenamiento de mercadería en bodega.",
          process: procesoSeguridad),
      Titulo(
          id: 11,
          name:
              "Incumplimiento de medidas de seguridad para exhibición y/o almacenamiento de mercadería en piso de venta.",
          process: procesoSeguridad),
      Titulo(
          id: 12,
          name: "Miembros de Brigada no cuentan con capacitación.",
          process: procesoSeguridad),
      Titulo(
          id: 13,
          name:
              "Pallets sin vitafilm desde la base y/o altura de éstos no cumplen estándares de almacenamiento.",
          process: procesoSeguridad),
      Titulo(
          id: 14,
          name:
              "Pruebas de activación del gabinete de LCI no se ejecutaron correctamente.",
          process: procesoSeguridad),
      Titulo(
          id: 15,
          name:
              "Pruebas de apertura de puertas de emergencia no se ejecutaron correctamente.",
          process: procesoSeguridad),
      Titulo(
          id: 16,
          name:
              "Riesgo de incendio por grasa acumulada en campanas, trampas de grasa y/u otras zonas de la tienda.",
          process: procesoSeguridad),
      Titulo(
          id: 17,
          name:
              "Temperatura en el gabinete principal de sistemas no cumple estándares.",
          process: procesoSeguridad),
      Titulo(
          id: 18,
          name:
              "Uso de apilador por parte de colaboradores sin evidencia de capacitación o que no están autorizados.",
          process: procesoSeguridad),
      Titulo(
          id: 19,
          name:
              "Uso de extensión eléctrica, adaptadores y/o dispositivos eléctricos no autorizados en los estándares.",
          process: procesoSeguridad),
      Titulo(
          id: 20,
          name: "Rutas de evacuación obstaculizadas total o parcialmente.",
          process: procesoSeguridad),
      Titulo(
          id: 21,
          name:
              "Válvulas de corte del Sistema LCI (Manifold) no emiten alerta en panel y/o no operan adecuadamente.",
          process: procesoSeguridad),
      Titulo(
          id: 22,
          name: "Puenteo de interruptores diferenciales.",
          process: procesoSeguridad),
      Titulo(
          id: 23,
          name:
              "Panel de Lucha Contra Incendio (LCI) presenta falsa(s) alerta(s).",
          process: procesoSeguridad),
      Titulo(
          id: 24,
          name: "Falla o ausencia del sistema puesta tierra en equipos.",
          process: procesoSeguridad),
      Titulo(
          id: 25,
          name: "Condiciones inseguras en ambientes o zonas de la tienda.",
          process: procesoSeguridad),
      Titulo(
          id: 26,
          name: "Pruebas y/o inspecciones no se ejecutaron correctamente.",
          process: procesoSeguridad),

      Titulo(
          id: 27,
          name:
              "Condiciones de limpieza en piso de venta, trastienda y/u otras zonas de la tienda no cumplen estándares.",
          process: procesoCalidad),
      Titulo(
          id: 28,
          name:
              "Condiciones organolépticas de productos no cumplen estándares para la venta.",
          process: procesoCalidad),
      Titulo(
          id: 29,
          name: "Incumplimiento de condiciones de refrigeración de mercadería.",
          process: procesoCalidad),
      Titulo(
          id: 30,
          name: "Presencia de óxido en equipos o instalaciones en tienda.",
          process: procesoCalidad),
      Titulo(
          id: 31,
          name: "Presencia de vectores en piso de venta y/o trastienda.",
          process: procesoCalidad),
      Titulo(
          id: 32,
          name:
              "Productos exhibidos en sala de ventas sin fecha de vencimiento.",
          process: procesoCalidad),
      Titulo(
          id: 33,
          name: "Productos no retirados oportunamente.",
          process: procesoCalidad),
      Titulo(
          id: 34,
          name: "Productos vencidos en piso de venta.",
          process: procesoCalidad),
      Titulo(
          id: 35,
          name:
              "Cámara de frío / Walk in freezer no cumple con estándares de conservación.",
          process: procesoCalidad),
      Titulo(
          id: 36,
          name:
              "Falla o falta de mantenimiento en los dispositivos de control de vectores y plagas.",
          process: procesoCalidad),
      Titulo(
          id: 37,
          name: "Manipulación inadecuada de productos perecibles.",
          process: procesoCalidad),

      Titulo(
          id: 38,
          name:
              "Certificado de limpieza y desinfección de cisternas de agua potable y LCI vencido.",
          process: procesoCumplimiento),
      Titulo(
          id: 39,
          name: "Falta o errores en el registro de entrega de EPPs.",
          process: procesoCumplimiento),
      Titulo(
          id: 40,
          name:
              "Layout de sala de venta, trastienda y otras zonas de la tienda no coincide con plano de arquitectura.",
          process: procesoCumplimiento),
      Titulo(
          id: 41,
          name: "Falta de publicación de letreros normativos.",
          process: procesoCumplimiento),
      Titulo(
          id: 42,
          name:
              "Locatarios: Licencia de funcionamiento, Certificado ITSE, Uso indebido de espacios.",
          process: procesoCumplimiento),

      Titulo(
          id: 43,
          name:
              "Errores o incumplimiento del procedimiento sobre arqueos inopinados del fondo de las cajas registradoras.",
          process: procesoOperaciones),
      Titulo(
          id: 44,
          name:
              "Ausencia o falla en la operación del botón de pánico en Tesorería o no emite alerta a G4S/Prosegur.",
          process: procesoOperaciones),
      Titulo(
          id: 45,
          name:
              "Falta de control en gestión de accesos a paneles biométricos y/o caja fuerte o bóveda de Tesorería.",
          process: procesoOperaciones),
      Titulo(
          id: 46,
          name:
              "Incumplimiento de lineamientos sobre la entrega y uso del fondo de para cambio de sencillo.",
          process: procesoOperaciones),
      Titulo(
          id: 47,
          name:
              "Incumplimiento en la ejecución de los arqueos del fondo de bóveda.",
          process: procesoOperaciones),
      Titulo(
          id: 48,
          name: "Incumplimiento en la administración del fondo fijo de bóveda.",
          process: procesoOperaciones),
      Titulo(
          id: 49,
          name: "Incumplimiento del procedimiento de pick up.",
          process: procesoOperaciones),
      Titulo(
          id: 50,
          name: "Controles declarados no ejecutados.",
          process: procesoOperaciones),
      Titulo(
          id: 51,
          name: "Trabajos de mantenimiento crìticos pendientes de reportar.",
          process: procesoOperaciones),
      Titulo(
          id: 52,
          name: "Incumplimiento de procesos de Clase 100.",
          process: procesoOperaciones),
      Titulo(
          id: 53,
          name:
              "Notas de crédito sin firma de Supervisor o incumplen procedimientos.",
          process: procesoOperaciones),
      Titulo(
          id: 54,
          name:
              "Niveles no aceptados de pruebas físico-químicas de aceite dieléctrico.",
          process: procesoOperaciones),
      Titulo(
          id: 55,
          name:
              "Problemas con equipos de aire acondicionado, UPS y otros similares.",
          process: procesoOperaciones),
      Titulo(
          id: 56,
          name: "Notas de Crédito no cuentan con VoBo de Gerente de Tienda.",
          process: procesoOperaciones),
      Titulo(
          id: 57,
          name:
              "Filtraciones o presencia de humedad en sala de ventas, trastienda o ambientes críticos.",
          process: procesoOperaciones),
      Titulo(
          id: 58,
          name:
              "Dispositivo(s) de detección no emite(n) alerta en el panel de LCI y/o no opera(n) adecuadamente.",
          process: procesoOperaciones),
      Titulo(
          id: 59,
          name:
              "Trabajos de mantenimiento preventivo no programados en el cronograma anual.",
          process: procesoOperaciones),
    ];

    return titulos;
  }

  List<dynamic> getAllTitulosMetodo() {
    final Proceso procesoSeguridad = Proceso(
      id: 1,
      name: "Seguridad Física",
      abbreviation: "SF",
    );

    final Proceso procesoCalidad = Proceso(
      id: 2,
      name: "Calidad",
      abbreviation: "CA",
    );

    final Proceso procesoCumplimiento = Proceso(
      id: 3,
      name: "Cumplimiento Normativo",
      abbreviation: "CN",
    );

    final Proceso procesoOperaciones = Proceso(
      id: 4,
      name: "Operaciones",
      abbreviation: "OP",
    );

    List<Titulo> titulos = [
      Titulo(
          id: 1,
          name:
              "Ambientes de la tienda no cuentan con detector de humo o presenta fallas en su operación.",
          process: procesoSeguridad),
      Titulo(
          id: 2,
          name:
              "Ausencia u otras situaciones identificadas relacionadas con extintores de acetato de potasio (grasas).",
          process: procesoSeguridad),
      Titulo(
          id: 3,
          name:
              "Colaborador(es) no usa(n) equipos de protección personal (EPP).",
          process: procesoSeguridad),
      Titulo(
          id: 4,
          name: "Acumulación de escarcha en la cámara de congelados.",
          process: procesoSeguridad),
      Titulo(
          id: 5,
          name:
              "Condiciones de riesgo eléctrico en tableros eléctricos, dispositivos eléctricos y otros.",
          process: procesoSeguridad),
      Titulo(
          id: 6,
          name:
              "Fallos en la operación de puertas de emergencia y/o falta de alerta al panel de intrusión.",
          process: procesoSeguridad),
      Titulo(
          id: 7,
          name: "Fallos en sistema CCTV y/o situaciones no reportadas al COE.",
          process: procesoSeguridad),
      Titulo(
          id: 8,
          name: "Inadecuado almacenamiento de balones GLP.",
          process: procesoSeguridad),
      Titulo(
          id: 9,
          name:
              "Inadecuado almacenamiento y estado de conservación de extintores.",
          process: procesoSeguridad),
      Titulo(
          id: 10,
          name:
              "Incumplimiento de medidas de seguridad para almacenamiento de mercadería en bodega.",
          process: procesoSeguridad),
      Titulo(
          id: 11,
          name:
              "Incumplimiento de medidas de seguridad para exhibición y/o almacenamiento de mercadería en piso de venta.",
          process: procesoSeguridad),
      Titulo(
          id: 12,
          name: "Miembros de Brigada no cuentan con capacitación.",
          process: procesoSeguridad),
      Titulo(
          id: 13,
          name:
              "Pallets sin vitafilm desde la base y/o altura de éstos no cumplen estándares de almacenamiento.",
          process: procesoSeguridad),
      Titulo(
          id: 14,
          name:
              "Pruebas de activación del gabinete de LCI no se ejecutaron correctamente.",
          process: procesoSeguridad),
      Titulo(
          id: 15,
          name:
              "Pruebas de apertura de puertas de emergencia no se ejecutaron correctamente.",
          process: procesoSeguridad),
      Titulo(
          id: 16,
          name:
              "Riesgo de incendio por grasa acumulada en campanas, trampas de grasa y/u otras zonas de la tienda.",
          process: procesoSeguridad),
      Titulo(
          id: 17,
          name:
              "Temperatura en el gabinete principal de sistemas no cumple estándares.",
          process: procesoSeguridad),
      Titulo(
          id: 18,
          name:
              "Uso de apilador por parte de colaboradores sin evidencia de capacitación o que no están autorizados.",
          process: procesoSeguridad),
      Titulo(
          id: 19,
          name:
              "Uso de extensión eléctrica, adaptadores y/o dispositivos eléctricos no autorizados en los estándares.",
          process: procesoSeguridad),
      Titulo(
          id: 20,
          name: "Rutas de evacuación obstaculizadas total o parcialmente.",
          process: procesoSeguridad),
      Titulo(
          id: 21,
          name:
              "Válvulas de corte del Sistema LCI (Manifold) no emiten alerta en panel y/o no operan adecuadamente.",
          process: procesoSeguridad),
      Titulo(
          id: 22,
          name: "Puenteo de interruptores diferenciales.",
          process: procesoSeguridad),
      Titulo(
          id: 23,
          name:
              "Panel de Lucha Contra Incendio (LCI) presenta falsa(s) alerta(s).",
          process: procesoSeguridad),
      Titulo(
          id: 24,
          name: "Falla o ausencia del sistema puesta tierra en equipos.",
          process: procesoSeguridad),
      Titulo(
          id: 25,
          name: "Condiciones inseguras en ambientes o zonas de la tienda.",
          process: procesoSeguridad),
      Titulo(
          id: 26,
          name: "Pruebas y/o inspecciones no se ejecutaron correctamente.",
          process: procesoSeguridad),

      Titulo(
          id: 27,
          name:
              "Condiciones de limpieza en piso de venta, trastienda y/u otras zonas de la tienda no cumplen estándares.",
          process: procesoCalidad),
      Titulo(
          id: 28,
          name:
              "Condiciones organolépticas de productos no cumplen estándares para la venta.",
          process: procesoCalidad),
      Titulo(
          id: 29,
          name: "Incumplimiento de condiciones de refrigeración de mercadería.",
          process: procesoCalidad),
      Titulo(
          id: 30,
          name: "Presencia de óxido en equipos o instalaciones en tienda.",
          process: procesoCalidad),
      Titulo(
          id: 31,
          name: "Presencia de vectores en piso de venta y/o trastienda.",
          process: procesoCalidad),
      Titulo(
          id: 32,
          name:
              "Productos exhibidos en sala de ventas sin fecha de vencimiento.",
          process: procesoCalidad),
      Titulo(
          id: 33,
          name: "Productos no retirados oportunamente.",
          process: procesoCalidad),
      Titulo(
          id: 34,
          name: "Productos vencidos en piso de venta.",
          process: procesoCalidad),
      Titulo(
          id: 35,
          name:
              "Cámara de frío / Walk in freezer no cumple con estándares de conservación.",
          process: procesoCalidad),
      Titulo(
          id: 36,
          name:
              "Falla o falta de mantenimiento en los dispositivos de control de vectores y plagas.",
          process: procesoCalidad),
      Titulo(
          id: 37,
          name: "Manipulación inadecuada de productos perecibles.",
          process: procesoCalidad),

      Titulo(
          id: 38,
          name:
              "Certificado de limpieza y desinfección de cisternas de agua potable y LCI vencido.",
          process: procesoCumplimiento),
      Titulo(
          id: 39,
          name: "Falta o errores en el registro de entrega de EPPs.",
          process: procesoCumplimiento),
      Titulo(
          id: 40,
          name:
              "Layout de sala de venta, trastienda y otras zonas de la tienda no coincide con plano de arquitectura.",
          process: procesoCumplimiento),
      Titulo(
          id: 41,
          name: "Falta de publicación de letreros normativos.",
          process: procesoCumplimiento),
      Titulo(
          id: 42,
          name:
              "Locatarios: Licencia de funcionamiento, Certificado ITSE, Uso indebido de espacios.",
          process: procesoCumplimiento),

      Titulo(
          id: 43,
          name:
              "Errores o incumplimiento del procedimiento sobre arqueos inopinados del fondo de las cajas registradoras.",
          process: procesoOperaciones),
      Titulo(
          id: 44,
          name:
              "Ausencia o falla en la operación del botón de pánico en Tesorería o no emite alerta a G4S/Prosegur.",
          process: procesoOperaciones),
      Titulo(
          id: 45,
          name:
              "Falta de control en gestión de accesos a paneles biométricos y/o caja fuerte o bóveda de Tesorería.",
          process: procesoOperaciones),
      Titulo(
          id: 46,
          name:
              "Incumplimiento de lineamientos sobre la entrega y uso del fondo de para cambio de sencillo.",
          process: procesoOperaciones),
      Titulo(
          id: 47,
          name:
              "Incumplimiento en la ejecución de los arqueos del fondo de bóveda.",
          process: procesoOperaciones),
      Titulo(
          id: 48,
          name: "Incumplimiento en la administración del fondo fijo de bóveda.",
          process: procesoOperaciones),
      Titulo(
          id: 49,
          name: "Incumplimiento del procedimiento de pick up.",
          process: procesoOperaciones),
      Titulo(
          id: 50,
          name: "Controles declarados no ejecutados.",
          process: procesoOperaciones),
      Titulo(
          id: 51,
          name: "Trabajos de mantenimiento crìticos pendientes de reportar.",
          process: procesoOperaciones),
      Titulo(
          id: 52,
          name: "Incumplimiento de procesos de Clase 100.",
          process: procesoOperaciones),
      Titulo(
          id: 53,
          name:
              "Notas de crédito sin firma de Supervisor o incumplen procedimientos.",
          process: procesoOperaciones),
      Titulo(
          id: 54,
          name:
              "Niveles no aceptados de pruebas físico-químicas de aceite dieléctrico.",
          process: procesoOperaciones),
      Titulo(
          id: 55,
          name:
              "Problemas con equipos de aire acondicionado, UPS y otros similares.",
          process: procesoOperaciones),
      Titulo(
          id: 56,
          name: "Notas de Crédito no cuentan con VoBo de Gerente de Tienda.",
          process: procesoOperaciones),
      Titulo(
          id: 57,
          name:
              "Filtraciones o presencia de humedad en sala de ventas, trastienda o ambientes críticos.",
          process: procesoOperaciones),
      Titulo(
          id: 58,
          name:
              "Dispositivo(s) de detección no emite(n) alerta en el panel de LCI y/o no opera(n) adecuadamente.",
          process: procesoOperaciones),
      Titulo(
          id: 59,
          name:
              "Trabajos de mantenimiento preventivo no programados en el cronograma anual.",
          process: procesoOperaciones),
    ];

    return titulos;
  }
}
