<?php
/**
*@package pXP
*@file gen-MODIntTransaccion.php
*@author  (admin)
*@date 01-09-2013 18:10:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/
/**
HISTORIAL DE MODIFICACIONES:
ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
#2        	19/12/2108		  	Miguel Mamani	  	reporte proyectos excel
#92 		19/12/2108		  	Miguel Mamani	  	actualización reporte de detalle de auxiliares
#6 			27/12/2108		  	Manuel Guerra	  	agrego el filtro de cbtes de cierre
#10       	02/01/2019    		Miguel Mamani     	Nuevo parámetro tipo de moneda para el reporte detalle Auxiliares por Cuenta
#65        	11/07/2019       	EGS             	Se agrega cmp internacional
#64  ETR    15/07/2019          MMV                 Incluir importe formulado reporte proyectos
#69  ETR    01/08/2019          SAZ                 Mejoras al reporte Comprobante transacciones
#75 		28/11/2019		    Manuel Guerra	    controlling
#91         15/01/2020          JUAN                Libro mayor añadir columna beneficiario
#83 		03/01/2020		    Miguel Mamani	    Reporte Auxiliares aumentar columna beneficiario
#93 		16/01/2020		    Manuel Guerra	  	modificacion en interfaz, ocultar columnas
#95         23/01/2020          Rensi Arteaga       Incluir nro de tramite auxiliar
#99 		30/1/2020		  Manuel Guerra	    agregar columna de estado_wf y proceso_wf
#102        6/2/2020          Manuel Guerra     agregar campo nro_tramite_auxiliar, en vista del mayor
 */
class MODIntTransaccion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTRANSA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_moneda','id_moneda','int4');
		
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mb','numeric');
		$this->capturaCount('total_haber_mb','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
		$this->capturaCount('total_gasto','numeric');
		$this->capturaCount('total_recurso','numeric');
		
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_transaccion','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_int_transaccion_fk','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('glosa','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');		
		$this->captura('desc_partida','text');
		$this->captura('desc_centro_costo','text');
		$this->captura('desc_cuenta','text');
		$this->captura('desc_auxiliar','text');
		$this->captura('tipo_partida','varchar');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('desc_orden','varchar');
		$this->captura('importe_debe','numeric');	
		$this->captura('importe_haber','numeric');
		$this->captura('importe_gasto','numeric');
		$this->captura('importe_recurso','numeric');
		
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		$this->captura('importe_recurso_mb','numeric');
		
		$this->captura('banco','varchar');
		$this->captura('forma_pago','varchar');
		$this->captura('nombre_cheque_trans','varchar');
		$this->captura('nro_cuenta_bancaria_trans','varchar');
		$this->captura('nro_cheque','INTEGER');
		
		$this->captura('importe_debe_mt','numeric');	
        $this->captura('importe_haber_mt','numeric');
        $this->captura('importe_gasto_mt','numeric');
        $this->captura('importe_recurso_mt','numeric');
		
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('importe_gasto_ma','numeric');
		$this->captura('importe_recurso_ma','numeric');
		
        $this->captura('id_moneda_tri','INTEGER');
        $this->captura('id_moneda_act','INTEGER');
        $this->captura('id_moneda','INTEGER');
		
        $this->captura('tipo_cambio','numeric');
        $this->captura('tipo_cambio_2','numeric');
        $this->captura('tipo_cambio_3','numeric');
		
		$this->captura('actualizacion','varchar');
		$this->captura('triangulacion','varchar');
		$this->captura('id_suborden','int4');
		$this->captura('desc_suborden','varchar');
		$this->captura('codigo_ot','varchar');
		$this->captura('codigo_categoria','varchar');
		$this->captura('nro_tramite_auxiliar','varchar'); //#95

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_INTRANSA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_int_transaccion_fk','id_int_transaccion_fk','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('glosa','glosa','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		
		$this->setParametro('importe_debe','importe_debe','numeric');
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');
		
		$this->setParametro('importe_debe_mb','importe_debe','numeric');
		$this->setParametro('importe_haber_mb','importe_haber','numeric');
		$this->setParametro('importe_gasto_mb','importe_gasto','numeric');
		$this->setParametro('importe_recurso_mb','importe_recurso','numeric');
		
		$this->setParametro('id_moneda_tri','id_moneda_tri','INTEGER');		
		$this->setParametro('id_moneda_act','id_moneda_act','INTEGER');
        $this->setParametro('id_moneda','id_moneda','INTEGER');
        $this->setParametro('tipo_cambio','tipo_cambio','numeric');
        $this->setParametro('tipo_cambio_2','tipo_cambio_2','numeric');
        $this->setParametro('tipo_cambio_3','tipo_cambio_3','numeric');
		$this->setParametro('id_suborden','id_suborden','int4');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarIntTransaccionXLS(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_TRANSAXLS_INS';
		$this->tipo_procedimiento='IME';		
		
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('centro_costo','centro_costo','varchar');
		$this->setParametro('partida','partida','varchar');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('auxiliar','auxiliar','varchar');
		$this->setParametro('orden','orden','varchar');
		$this->setParametro('suborden','suborden','varchar');        
		$this->setParametro('debe','debe','varchar');
		$this->setParametro('haber','haber','varchar');
		$this->setParametro('glosa','glosa','varchar');		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_INTRANSA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_partida_ejecucion','id_partida_ejecucion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_int_transaccion_fk','id_int_transaccion_fk','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('glosa','glosa','text');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		
		$this->setParametro('importe_debe','importe_debe','numeric');
		$this->setParametro('importe_haber','importe_haber','numeric');
		$this->setParametro('importe_gasto','importe_gasto','numeric');
		$this->setParametro('importe_recurso','importe_recurso','numeric');
		
		$this->setParametro('importe_debe_mb','importe_debe','numeric');
		$this->setParametro('importe_haber_mb','importe_haber','numeric');
		$this->setParametro('importe_gasto_mb','importe_gasto','numeric');
		$this->setParametro('importe_recurso_mb','importe_recurso','numeric');
		
		$this->setParametro('id_moneda_tri','id_moneda_tri','INTEGER');
		$this->setParametro('id_moneda_act','id_moneda_act','INTEGER');
        $this->setParametro('id_moneda','id_moneda','INTEGER');
        $this->setParametro('tipo_cambio','tipo_cambio','numeric');
        $this->setParametro('tipo_cambio_2','tipo_cambio_2','numeric');
		$this->setParametro('tipo_cambio_3','tipo_cambio_3','numeric');
		$this->setParametro('id_suborden','id_suborden','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarIntTransaccion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_INTRANSA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

   function guardarDatosBancos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_transaccion_ime';
		$this->transaccion='CONTA_SAVTRABAN_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');
		$this->setParametro('nombre_cheque_trans','nombre_cheque_trans','varchar');
		$this->setParametro('forma_pago','forma_pago','varchar');
		$this->setParametro('nro_cheque','nro_cheque','int4');		
		$this->setParametro('nro_cuenta_bancaria','nro_cuenta_bancaria','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	//mp
	#6
   function listarIntTransaccionMayor(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTMAY_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('tipo_filtro','tipo_filtro','varchar');
		
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('cerrado','cerrado','varchar');
		$this->setParametro('cbte_cierre','cbte_cierre','varchar');
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
		
		$this->capturaCount('total_saldo_mb','numeric');
		$this->capturaCount('total_saldo_mt','numeric');
		$this->capturaCount('dif','numeric');		
		//Definicion de la lista del resultado del query
		$this->captura('id_int_transaccion','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		
		$this->captura('id_int_transaccion_fk','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('glosa','varchar');		
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_auxiliar','int4');
		
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','date');
		$this->captura('id_usuario_mod','int4');		
		$this->captura('fecha_mod','date');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		$this->captura('importe_recurso_mb','numeric');
		
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_gasto_mt','numeric');
		$this->captura('importe_recurso_mt','numeric');
		
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('importe_gasto_ma','numeric');
		$this->captura('importe_recurso_ma','numeric');
		
		$this->captura('desc_partida','varchar');
		$this->captura('desc_centro_costo','varchar');
		$this->captura('desc_cuenta','varchar');
		$this->captura('desc_auxiliar','varchar');
		$this->captura('tipo_partida','varchar');
		
		$this->captura('id_orden_trabajo','int4');
		$this->captura('desc_orden','varchar');		
		$this->captura('nro_cbte','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('nombre_corto','varchar');
		
		$this->captura('fecha','date');
		$this->captura('glosa1','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');		 
		$this->captura('cbte_relacional','varchar');
			
		$this->captura('tipo_cambio','numeric');
		$this->captura('tipo_cambio_2','numeric');
		$this->captura('tipo_cambio_3','numeric');
		$this->captura('actualizacion','varchar');
		$this->captura('codigo_cc','varchar');
        $this->captura('nro_tramite_auxiliar','varchar');//#102
		
		$this->captura('saldo_mb','numeric');
		$this->captura('saldo_mt','numeric');
		$this->captura('dif','numeric');
        $this->captura('beneficiario','varchar');//#91
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

   function listarIntTransaccionOrden(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTANA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
			
		//Definicion de la lista del resultado del query
		$this->captura('id_orden_trabajo','int4');
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('codigo_ot','varchar');
		$this->captura('desc_orden','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
   }

    function listarIntTransaccionPartida(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTPAR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
			
		//Definicion de la lista del resultado del query
		$this->captura('id_partida','int4');
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('codigo_partida','varchar');
		$this->captura('sw_movimiento','varchar');
		$this->captura('descripcion_partida','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarIntTransaccionCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_INTCUE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		
		//captura parametros adicionales para el count
		$this->capturaCount('total_debe','numeric');
		$this->capturaCount('total_haber','numeric');
		$this->capturaCount('total_debe_mt','numeric');
		$this->capturaCount('total_haber_mt','numeric');
		$this->capturaCount('total_debe_ma','numeric');
		$this->capturaCount('total_haber_ma','numeric');
			
		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta','int4');
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('codigo_cuenta','varchar');
		$this->captura('tipo_cuenta','varchar');
		$this->captura('descripcion_cuenta','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarIntTransaccionRepMayor(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_REPMAY_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('tipo_filtro','tipo_filtro','varchar');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('desde','desde','date');
		
		$this->setParametro('datos','datos','varchar');

		$this->captura('id_int_transaccion','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_int_transaccion_fk','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('glosa','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		$this->captura('importe_recurso_mb','numeric');
		
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_gasto_mt','numeric');
		$this->captura('importe_recurso_mt','numeric');
		
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('importe_gasto_ma','numeric');
		$this->captura('importe_recurso_ma','numeric');
		
		$this->captura('desc_partida','text');
		$this->captura('desc_centro_costo','text');
		$this->captura('desc_cuenta','text');
		$this->captura('desc_auxiliar','text');
		$this->captura('tipo_partida','varchar');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('desc_orden','varchar');		
		$this->captura('nro_cbte','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('nombre_corto','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa1','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('cbte_relacional','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		
		return $this->respuesta;
	}
	//
	function listarAuxiliarCuenta(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_AUXMAY_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('id_config_subtipo_cuenta','id_config_subtipo_cuenta','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('tipo','tipo','varchar');	
		$this->setParametro('tipo_estado','tipo_estado','varchar');	
		//captura parametros adicionales para el count
		$this->capturaCount('total_importe_debe_mb','numeric');
		$this->capturaCount('total_importe_haber_mb','numeric');
		$this->capturaCount('total_saldo_mb','numeric');
		
		$this->captura('id_auxiliar','int4');
		$this->captura('codigo_auxiliar','varchar');
		$this->captura('nombre_auxiliar','varchar');
		$this->captura('id_cuenta','int4');
		$this->captura('nro_cuenta','varchar');
		$this->captura('nombre_cuenta','varchar');
		$this->captura('tipo_cuenta','varchar');
		$this->captura('sub_tipo_cuenta','varchar');
		$this->captura('desc_sub_tipo_cuenta','varchar');
		$this->captura('id_config_subtipo_cuenta','int4');
		
		$this->captura('importe_debe_mb','numeric');
		$this->captura('importe_haber_mb','numeric');
		$this->captura('saldo','numeric');
		$this->captura('intenacional','varchar'); //#65
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	//
	function listarTotal(){ 
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_TOTAUX_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('id_config_subtipo_cuenta','id_config_subtipo_cuenta','int4');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('tipo','tipo','varchar');		
		$this->setParametro('tipo_estado','tipo_estado','varchar');	
		//captura parametros adicionales para el count
		//$this->capturaCount('total_saldo_mb','numeric');
		$this->capturaCount('total_importe_debe_mb','numeric');
		$this->capturaCount('total_importe_haber_mb','numeric');
		$this->capturaCount('total_saldo_mb','numeric');
			
		$this->captura('id_auxiliar','int4');
		$this->captura('codigo_auxiliar','varchar');
		$this->captura('nombre_auxiliar','varchar');
		$this->captura('id_cuenta','int4');
		$this->captura('nro_cuenta','varchar');
		$this->captura('nombre_cuenta','varchar');
		$this->captura('tipo_cuenta','varchar');
		$this->captura('sub_tipo_cuenta','varchar');
		$this->captura('desc_sub_tipo_cuenta','varchar');
		$this->captura('id_config_subtipo_cuenta','int4');
		
		$this->captura('importe_debe_mb','numeric');
		$this->captura('importe_haber_mb','numeric');
		$this->captura('saldo','numeric');
		$this->captura('intenacional','varchar'); //#65
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();		
		//Devuelve la respuesta
		return $this->respuesta;
	}		
	//
	function listarIntTransaccionRepMayorXXXXX(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_REPMAYSAL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('tipo_filtro','tipo_filtro','varchar');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('desde','desde','date');
		
		$this->setParametro('datos','datos','varchar');

		$this->captura('id_int_transaccion','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_int_transaccion_fk','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('glosa','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		$this->captura('importe_recurso_mb','numeric');
		
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_gasto_mt','numeric');
		$this->captura('importe_recurso_mt','numeric');
		
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('importe_gasto_ma','numeric');
		$this->captura('importe_recurso_ma','numeric');
		
		$this->captura('desc_partida','text');
		$this->captura('desc_centro_costo','text');
		$this->captura('desc_cuenta','text');
		$this->captura('desc_auxiliar','text');
		$this->captura('tipo_partida','varchar');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('desc_orden','varchar');		
		$this->captura('nro_cbte','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('nombre_corto','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa1','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('cbte_relacional','varchar');
		$this->captura('saldo','numeric');	
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	//mp
	function listarMayorSaldo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_REPMAYSAL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('tipo_filtro','tipo_filtro','varchar');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('desde','desde','date');
		
		$this->setParametro('datos','datos','varchar');
		//Definicion de la lista del resultado del query
		$this->captura('id_int_transaccion','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_int_transaccion_fk','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('glosa','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_auxiliar','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','date');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','date');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('importe_debe_mb','numeric');	
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		$this->captura('importe_recurso_mb','numeric');
		
		$this->captura('importe_debe_mt','numeric');	
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_gasto_mt','numeric');
		$this->captura('importe_recurso_mt','numeric');
		
		$this->captura('importe_debe_ma','numeric');	
		$this->captura('importe_haber_ma','numeric');
		$this->captura('importe_gasto_ma','numeric');
		$this->captura('importe_recurso_ma','numeric');
		
		$this->captura('desc_partida','varchar');
		$this->captura('desc_centro_costo','varchar');
		$this->captura('desc_cuenta','varchar');
		$this->captura('desc_auxiliar','varchar');
		$this->captura('tipo_partida','varchar');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('desc_orden','varchar');		
		$this->captura('nro_cbte','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('nombre_corto','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa1','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('cbte_relacional','varchar');
		$this->captura('saldo','numeric');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	function listaDetalleComprobanteTransacciones(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_transaccion_sel';
		$this->transaccion='CONTA_LDCTRANS_SEL';
		$this->tipo_procedimiento='SEL';
		
		//$this->setCount(false);	
		$this->setParametro('tipo_reporte','tipo_reporte','varchar');
			
		$this->captura('id_int_transaccion','int4');
		$this->captura('id_int_comprobante','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha','date');
		$this->captura('nro_cbte','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('glosa1','varchar');
		$this->captura('debe_mb','numeric');
		$this->captura('haber_mb','numeric');
		$this->captura('saldo_debehaber_mb','numeric');

		// #69

		$this->captura('debe_mt','numeric');
		$this->captura('haber_mt','numeric');
		$this->captura('saldo_debehaber_mt','numeric');

        // #69

		$this->captura('debe_ma','numeric');
		$this->captura('haber_ma','numeric');
		$this->captura('saldo_debehaber_ma','numeric');

        // #69
		
		$this->captura('tc_ufv','numeric');
		$this->captura('tipo_cuenta','varchar');
		$this->captura('cuenta_nro','varchar');
		$this->captura('cuenta','varchar');
		
		$this->captura('partida_tipo','varchar');
		$this->captura('partida_codigo','varchar');
		$this->captura('partida','varchar');
		
		$this->captura('centro_costo_techo_codigo','varchar');
		$this->captura('centro_costo_techo','varchar');
		$this->captura('centro_costo_codigo','varchar');
		$this->captura('centro_costo','varchar');
		
		$this->captura('aux_codigo','varchar');
		$this->captura('aux_nombre','varchar');
		
		$this->captura('tipo_transaccion','varchar');
		$this->captura('periodo','varchar');
		$this->captura('hora','varchar');
		$this->captura('fecha_reg_transaccion','timestamp');
		$this->captura('usuario_reg_transaccion','varchar');
		$this->captura('nro_documento','varchar');
		$this->captura('glosa_transaccion','varchar');
		$this->captura('nombre','varchar');

        // #69
        $this->captura('beneficiario','varchar');
        $this->captura('tipo_cbte','varchar');
        $this->captura('glosa','varchar');
        $this->captura('persona_create','text');
        $this->captura('persona_mod','text');
        $this->captura('nro_tramite_aux','varchar');
		//$this->captura('beneficiario','varchar');
		/*
		$this->captura('fecha','timestamp');
		$this->captura('nro_cbte','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('glosa1','varchar');*/
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//var_dump($this->armarConsulta());
		//Devuelve la respuesta
		return $this->respuesta;
	}
    /***************#92-INI-MMV**************/
    function mayorNroTramite(){
        $this->procedimiento='conta.ft_int_transaccion_sel';
        $this->transaccion='CONTA_MROMAYOR_SEL';
        $this->tipo_procedimiento='SEL';

        $this->setParametro('desde','desde','date');
        $this->setParametro('hasta','hasta','date');
        $this->setParametro('id_auxiliar','id_auxiliar','int4');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('nro_tramite','nro_tramite','varchar');
        
        $this->capturaCount('importe_debe_mb_total','numeric');
        $this->capturaCount('importe_haber_mb_total','numeric');
        $this->capturaCount('saldo_mb_total','numeric');

        $this->capturaCount('importe_debe_mt_total','numeric');
        $this->capturaCount('importe_haber_mt_total','numeric');
        $this->capturaCount('saldo_mt_total','numeric');

        $this->capturaCount('importe_debe_ma_total','numeric');
        $this->capturaCount('importe_haber_ma_total','numeric');
        $this->capturaCount('saldo_ma_total','numeric');

        $this->captura('id_int_comprobante','int4');
        $this->captura('id_cuenta','int4');
        $this->captura('nro_cuenta','varchar');
        $this->captura('nombre_cuenta','varchar');
        $this->captura('id_auxiliar','int4');
        $this->captura('codigo_auxiliar','varchar');
        $this->captura('nombre_auxiliar','varchar');
        $this->captura('nro_tramite','varchar');
        $this->captura('fecha','date');
        $this->captura('glosa1','varchar');
        $this->captura('importe_debe_mb','numeric');
        $this->captura('importe_haber_mb','numeric');
        $this->captura('saldo_mb','numeric');
        $this->captura('importe_debe_mt','numeric');
        $this->captura('importe_haber_mt','numeric');
        $this->captura('saldo_mt','numeric');
        $this->captura('importe_debe_ma','numeric');
        $this->captura('importe_haber_ma','numeric');
        $this->captura('saldo_ma','numeric');

        $this->armarConsulta();
        $this->ejecutarConsulta();
        return $this->respuesta;
    }
    function mayorNroTramiteReporte(){
        $this->procedimiento='conta.ft_int_transaccion_sel';
        $this->transaccion='CONTA_AUXRE_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);
        $this->setParametro('desde','desde','date');
        $this->setParametro('hasta','hasta','date');
        $this->setParametro('id_auxiliar','id_auxiliar','int4');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('nro_tramite','nro_tramite','varchar');

        $this->captura('id_int_comprobante','int4');
        $this->captura('id_cuenta','int4');
        $this->captura('nro_cuenta','varchar');
        $this->captura('nombre_cuenta','varchar');
        $this->captura('id_auxiliar','int4');
        $this->captura('codigo_auxiliar','varchar');
        $this->captura('nombre_auxiliar','varchar');
        $this->captura('nro_tramite','varchar');
        $this->captura('fecha','date');
        $this->captura('glosa1','varchar');
        $this->captura('importe_debe_mb','numeric');
        $this->captura('importe_haber_mb','numeric');
        $this->captura('saldo_mb','numeric');
        $this->captura('importe_debe_mt','numeric');
        $this->captura('importe_haber_mt','numeric');
        $this->captura('tipo','varchar');
        $this->captura('beneficiario','varchar'); //#83

        $this->armarConsulta();
        $this->ejecutarConsulta();
        return $this->respuesta;
    }
    /***************#92-FIN-MMV**************/
    /***************#2-INI-MMV**************/
    function reporteProyecto(){
        $this->procedimiento='conta.f_reporte_centro_costo';
        $this->transaccion='CONTA_CCR_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this-> setCount(false);
        $this->setTipoRetorno('record');

        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('desde','desde','date');
        $this->setParametro('hasta','hasta','date');
        $this->setParametro('id_cuenta','id_cuenta','int4');
        $this->setParametro('id_tipo_cc','id_tipo_cc','int4');
        $this->setParametro('id_centro_costo','id_centro_costo','int4');
        $this->setParametro('cbte_cierre','cbte_cierre','varchar');
        $this->setParametro('tipo_moneda','tipo_moneda','varchar'); //#10

        $this->captura('id_tipo_cc','int4');
        $this->captura('id_tipo_cc_fk','int4');
        $this->captura('codigo_tcc','varchar');
        $this->captura('importe_debe_mb','numeric');
        $this->captura('importe_haber_mb','numeric');
        $this->captura('saldo_mb','numeric');
        $this->captura('nivel','int4');
        $this->captura('sw_tipo','varchar');
        $this->captura('codigo','varchar');
        $this->captura('importe_formulado','numeric'); //#64
        $this->armarConsulta();

        $this->ejecutarConsulta();
        return $this->respuesta;
    }
    /***************#2-FIN-MMV**************/
    function listarMayorCtrl(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_int_transaccion_controlling_sel';
        $this->transaccion='CONTA_MAYCTR_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_moneda','id_moneda','int4');
        $this->setParametro('id_cuenta','id_cuenta','int4');
        $this->setParametro('id_partida','id_partida','int4');
        $this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
        $this->setParametro('id_tipo_cc','id_tipo_cc','int4');
        $this->setParametro('tipo_filtro','tipo_filtro','varchar');

        $this->setParametro('desde','desde','date');
        $this->setParametro('hasta','hasta','date');
        $this->setParametro('cerrado','cerrado','varchar');
        $this->setParametro('cbte_cierre','cbte_cierre','varchar');
		$this->setParametro('tipo','tipo','varchar');

        //captura parametros adicionales para el count
        $this->capturaCount('total_debe_mb','numeric');
        $this->capturaCount('total_haber_mb','numeric');
        $this->capturaCount('total_debe_mt','numeric');
        $this->capturaCount('total_haber_mt','numeric');
        $this->capturaCount('total_debe_ma','numeric');
        $this->capturaCount('total_haber_ma','numeric');

        $this->capturaCount('total_saldo_mb','numeric');
        $this->capturaCount('total_saldo_mt','numeric');
        $this->capturaCount('dif','numeric');
        //Definicion de la lista del resultado del query
        $this->captura('id_int_transaccion','int4');
        $this->captura('id_int_comprobante','int4');

        $this->captura('codigo','varchar');
        $this->captura('nro_cbte','varchar');
        $this->captura('nro_tramite','varchar');
        $this->captura('nro_tramite_aux','varchar');

        $this->captura('id_centro_costo','int4');
        $this->captura('id_partida_ejecucion','int4');
        $this->captura('id_cuenta','int4');
        $this->captura('id_partida','int4');
        $this->captura('id_auxiliar','int4');

        $this->captura('importe_debe_mb','numeric');
        $this->captura('importe_haber_mb','numeric');
        $this->captura('importe_gasto_mb','numeric');
        $this->captura('importe_recurso_mb','numeric');

        $this->captura('importe_debe_mt','numeric');
        $this->captura('importe_haber_mt','numeric');
        $this->captura('importe_gasto_mt','numeric');
        $this->captura('importe_recurso_mt','numeric');

        $this->captura('importe_debe_ma','numeric');
        $this->captura('importe_haber_ma','numeric');
        $this->captura('importe_gasto_ma','numeric');
        $this->captura('importe_recurso_ma','numeric');

        $this->captura('desc_centro_costo','varchar');
        $this->captura('desc_cuenta','varchar');
        $this->captura('desc_auxiliar','varchar');
        $this->captura('desc_partida','varchar');
        $this->captura('tipo_partida','varchar');
        $this->captura('nombre_corto','varchar');

        $this->captura('fecha','date');

        $this->captura('glosa_cbte','varchar');
        $this->captura('glosa_tran','varchar');

        $this->captura('tipo_cambio','numeric');
        $this->captura('tipo_cambio_2','numeric');
        $this->captura('tipo_cambio_3','numeric');
        $this->captura('actualizacion','varchar');

        $this->captura('saldo_mb','numeric');
        $this->captura('saldo_mt','numeric');
        $this->captura('dif','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    //#75
    function listarAgrupacion(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_int_transaccion_controlling_sel';
        $this->transaccion='CONTA_LISAGR_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_moneda','id_moneda','int4');
        $this->setParametro('id_cuenta','id_cuenta','int4');
        $this->setParametro('id_partida','id_partida','int4');
        $this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
        $this->setParametro('id_tipo_cc','id_tipo_cc','int4');
        $this->setParametro('tipo_filtro','tipo_filtro','varchar');
        $this->setParametro('ejecutado','ejecutado','numeric');

        $this->setParametro('desde','desde','date');
        $this->setParametro('hasta','hasta','date');
        $this->setParametro('cerrado','cerrado','varchar');
        $this->setParametro('cbte_cierre','cbte_cierre','varchar');
        $this->setParametro('numero','numero','integer');

        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('id_periodo','id_periodo','int4');
        //captura parametros adicionales para el count
        $this->capturaCount('total_debe_mb','numeric');
        $this->capturaCount('total_haber_mb','numeric');

        $this->capturaCount('total_debe_mt','numeric');
        $this->capturaCount('total_haber_mt','numeric');

        $this->capturaCount('monto_mb_total','numeric');
        $this->capturaCount('compro_total','numeric');
        $this->capturaCount('ejec_total','numeric');
        $this->capturaCount('formu_total','numeric');
        //Definicion de la lista del resultado del query
        $this->captura('tipo','varchar');
        $this->captura('id','integer');

        $this->captura('desde','date');
        $this->captura('hasta','date');
        $this->captura('id_tipo_cc','varchar');
        $this->captura('numero','integer');
        //$this->captura('id_subsistema','integer');
        // $this->captura('id','integer');
        $this->captura('ejecutado','numeric');
        //$this->captura('formulado','numeric');

        $this->captura('id_gestion','int4');
        $this->captura('id_periodo','int4');
        $this->captura('importe_debe_mb','numeric');
        $this->captura('importe_haber_mb','numeric');
        $this->captura('importe_debe_mt','numeric');
        $this->captura('importe_haber_mt','numeric');

        $this->captura('monto_mb','numeric');
        $this->captura('compro','numeric');
        $this->captura('ejec','numeric');
        $this->captura('formu','numeric');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    //#75
    function ListarProcesos(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_int_transaccion_controlling_sel';
        $this->transaccion='CONTA_PROAGR_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_moneda','id_moneda','int4');
        $this->setParametro('id_cuenta','id_cuenta','int4');
        $this->setParametro('id_partida','id_partida','int4');
        $this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
        $this->setParametro('id_tipo_cc','id_tipo_cc','int4');
        $this->setParametro('tipo_filtro','tipo_filtro','varchar');
        $this->setParametro('desde','desde','date');
        $this->setParametro('hasta','hasta','date');
        $this->setParametro('cerrado','cerrado','varchar');
        $this->setParametro('cbte_cierre','cbte_cierre','varchar');
        //Definicion de la lista del resultado del query

        $this->captura('id_int_transaccion','integer');
        $this->captura('nro_tramite','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    //ARBOL #75
    function listarTransArbol(){
        $this->procedimiento='conta.ft_int_transaccion_controlling_sel';
        $this->transaccion='CONTA_PROARB_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);

        $this->setParametro('node','node','varchar');
        /////////
        $this->setParametro('id_moneda','id_moneda','int4');
        $this->setParametro('id_cuenta','id_cuenta','int4');
        $this->setParametro('id_partida','id_partida','int4');
        $this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
        $this->setParametro('id_tipo_cc','id_tipo_cc','int4');
        $this->setParametro('tipo_filtro','tipo_filtro','varchar');
        $this->setParametro('desde','desde','date');
        $this->setParametro('hasta','hasta','date');
        $this->setParametro('cerrado','cerrado','varchar');
        $this->setParametro('cbte_cierre','cbte_cierre','varchar');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('id','id','int4');
        $this->setParametro('desc_centro_costo','desc_centro_costo','varchar');
        $this->setParametro('desc_partida','desc_partida','varchar');
        $this->setParametro('tramite','tramite','varchar');

        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('id_periodo','id_periodo','int4');
        /// ////////////////
        //defino varialbes que se captran como retornod e la funcion
        //$this->captura('id_int_transaccion','integer');
        // $this->captura('id_int_comprobante','integer');
        $this->captura('ids','integer');
        $this->captura('id_int_transaccion','integer');
        $this->captura('id_int_comprobante','integer');
        $this->captura(trim('nro_tramite', chr(0xC2).chr(0xA0)) ,'varchar');
        $this->captura('nro_tramite_fk','varchar');
        //#99
        $this->captura('id_proceso_wf','integer');
        $this->captura('id_estado_wf','integer');
        //$this->captura('desc_cuenta','varchar');
        $this->captura(trim('desc_cuenta', chr(0xC2).chr(0xA0)) ,'varchar');
        $this->captura('desc_auxiliar','varchar');
        $this->captura('desc_centro_costo','varchar');
        $this->captura('desc_partida','varchar');
        $this->captura('tipo_nodo','varchar');
        $this->captura('importe_debe_mb','numeric');
        $this->captura('importe_haber_mb','numeric');
        $this->captura('importe_debe_mt','numeric');
        $this->captura('importe_haber_mt','numeric');

        $this->armarConsulta();
        $this->ejecutarConsulta();
        return $this->respuesta;
    }
}
?>