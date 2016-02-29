<?php
/**
*@package pXP
*@file gen-MODPlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:40:00
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPlantillaComprobante extends MODbase{
	
	function __construct(CTParametro $pParam){ 
		parent::__construct($pParam);
	}
			
	function listarPlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_plantilla_comprobante_sel';
		$this->transaccion='CONTA_CMPB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_plantilla_comprobante','int4');
		$this->captura('codigo','varchar');
		$this->captura('funcion_comprobante_eliminado','text');
		$this->captura('idtabla','varchar');
		$this->captura('campo_subsistema','text');
		$this->captura('campo_descripcion','text');
		$this->captura('funcion_comprobante_validado','text');
		$this->captura('campo_fecha','text');
		$this->captura('estado_reg','varchar');
		$this->captura('campo_acreedor','text');
		$this->captura('campo_depto','text');
		$this->captura('momento_presupuestario','varchar');
		$this->captura('campo_fk_comprobante','text');
		$this->captura('tabla_origen','varchar');
		$this->captura('clase_comprobante','varchar');
		$this->captura('campo_moneda','text');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('campo_gestion_relacion','varchar');
		$this->captura('otros_campos','varchar');
		$this->captura('momento_comprometido','varchar');
        $this->captura('momento_ejecutado','varchar');
        $this->captura('momento_pagado','varchar');
		$this->captura('campo_id_cuenta_bancaria','varchar');
		$this->captura('campo_id_cuenta_bancaria_mov','varchar');
		$this->captura('campo_nro_cheque','varchar');
		$this->captura('campo_nro_cuenta_bancaria_trans','varchar');
		$this->captura('campo_nro_tramite','varchar');
		$this->captura('campo_tipo_cambio','varchar');
		$this->captura('campo_depto_libro','text');
		$this->captura('campo_fecha_costo_ini','text');
		$this->captura('campo_fecha_costo_fin','text');
		$this->captura('funcion_comprobante_editado','text');
		$this->captura('funcion_comprobante_prevalidado','text');
		$this->captura('funcion_comprobante_validado_eliminado','text');
		
        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plantilla_comprobante_ime';
		$this->transaccion='CONTA_CMPB_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('funcion_comprobante_eliminado','funcion_comprobante_eliminado','text');
		$this->setParametro('id_tabla','idtabla','varchar');
		$this->setParametro('campo_subsistema','campo_subsistema','consulta_select');
		$this->setParametro('campo_descripcion','campo_descripcion','consulta_select');
		$this->setParametro('funcion_comprobante_validado','funcion_comprobante_validado','consulta_select');
		$this->setParametro('campo_fecha','campo_fecha','consulta_select');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('campo_acreedor','campo_acreedor','consulta_select');
		$this->setParametro('campo_depto','campo_depto','consulta_select');
		$this->setParametro('momento_presupuestario','momento_presupuestario','varchar');
		$this->setParametro('campo_fk_comprobante','campo_fk_comprobante','consulta_select');
		$this->setParametro('tabla_origen','tabla_origen','text');
		$this->setParametro('clase_comprobante','clase_comprobante','varchar');
		$this->setParametro('campo_moneda','campo_moneda','consulta_select');
		$this->setParametro('campo_gestion_relacion','campo_gestion_relacion','varchar');
		$this->setParametro('otros_campos','otros_campos','varchar');
		
		$this->setParametro('momento_comprometido','momento_comprometido','varchar');
        $this->setParametro('momento_ejecutado','momento_ejecutado','varchar');
        $this->setParametro('momento_pagado','momento_pagado','varchar');
		$this->setParametro('campo_id_cuenta_bancaria','campo_id_cuenta_bancaria','varchar');
		$this->setParametro('campo_id_cuenta_bancaria_mov','campo_id_cuenta_bancaria_mov','varchar');
		$this->setParametro('campo_nro_cheque','campo_nro_cheque','varchar');
		
		$this->setParametro('campo_nro_tramite','campo_nro_tramite','varchar');
		$this->setParametro('campo_nro_cuenta_bancaria_trans','campo_nro_cuenta_bancaria_trans','varchar');
		$this->setParametro('campo_tipo_cambio','campo_tipo_cambio','varchar');
		$this->setParametro('campo_depto_libro','campo_depto_libro','text');
		
		$this->setParametro('campo_fecha_costo_ini','campo_fecha_costo_ini','text');
		$this->setParametro('campo_fecha_costo_fin','campo_fecha_costo_fin','text');
		$this->setParametro('funcion_comprobante_editado','funcion_comprobante_editado','text');
		$this->setParametro('funcion_comprobante_prevalidado','funcion_comprobante_prevalidado','text');
		$this->setParametro('funcion_comprobante_validado_eliminado','funcion_comprobante_validado_eliminado','text');
		
		
		
		
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plantilla_comprobante_ime';
		$this->transaccion='CONTA_CMPB_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_plantilla_comprobante','id_plantilla_comprobante','int4');
		$this->setParametro('funcion_comprobante_eliminado','funcion_comprobante_eliminado','consulta_select');
		$this->setParametro('id_tabla','idtabla','varchar');
		$this->setParametro('campo_subsistema','campo_subsistema','consulta_select');
		$this->setParametro('campo_descripcion','campo_descripcion','consulta_select');
		$this->setParametro('funcion_comprobante_validado','funcion_comprobante_validado','consulta_select');
		$this->setParametro('campo_fecha','campo_fecha','consulta_select');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('campo_acreedor','campo_acreedor','consulta_select');
		$this->setParametro('campo_depto','campo_depto','consulta_select');
		$this->setParametro('momento_presupuestario','momento_presupuestario','varchar');
		$this->setParametro('campo_fk_comprobante','campo_fk_comprobante','consulta_select');
		$this->setParametro('tabla_origen','tabla_origen','varchar');
		$this->setParametro('clase_comprobante','clase_comprobante','varchar');
		$this->setParametro('campo_moneda','campo_moneda','consulta_select');
		$this->setParametro('campo_gestion_relacion','campo_gestion_relacion','varchar');
        $this->setParametro('otros_campos','otros_campos','varchar');
        $this->setParametro('momento_comprometido','momento_comprometido','varchar');
        $this->setParametro('momento_ejecutado','momento_ejecutado','varchar');
        $this->setParametro('momento_pagado','momento_pagado','varchar');
		$this->setParametro('campo_id_cuenta_bancaria','campo_id_cuenta_bancaria','varchar');
		$this->setParametro('campo_id_cuenta_bancaria_mov','campo_id_cuenta_bancaria_mov','varchar');
		$this->setParametro('campo_nro_cheque','campo_nro_cheque','varchar');		
		$this->setParametro('campo_nro_cuenta_bancaria_trans','campo_nro_cuenta_bancaria_trans','varchar');
        $this->setParametro('campo_nro_tramite','campo_nro_tramite','varchar');
		$this->setParametro('campo_tipo_cambio','campo_tipo_cambio','varchar');
        $this->setParametro('campo_depto_libro','campo_depto_libro','text');
		$this->setParametro('campo_fecha_costo_ini','campo_fecha_costo_ini','text');
		$this->setParametro('campo_fecha_costo_fin','campo_fecha_costo_fin','text');
		$this->setParametro('funcion_comprobante_editado','funcion_comprobante_editado','text');
		$this->setParametro('funcion_comprobante_prevalidado','funcion_comprobante_prevalidado','text');
		$this->setParametro('funcion_comprobante_validado_eliminado','funcion_comprobante_validado_eliminado','text');
		
		
        
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plantilla_comprobante_ime';
		$this->transaccion='CONTA_CMPB_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_plantilla_comprobante','id_plantilla_comprobante','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function exportarDatos() {
		
		$this->procedimiento='conta.ft_plantilla_comprobante_sel';
			$this->transaccion='CONTA_EXPPC_SEL';
			$this->tipo_procedimiento='SEL';
			$this->setCount(false);
			
			$this->setParametro('id_plantilla_comprobante','id_plantilla_comprobante','integer');
			
			//Definicion de la lista del resultado del query
			$this->captura('tipo_reg','varchar');
			$this->captura('id_plantilla_comprobante','int4');
			$this->captura('codigo','varchar');
			$this->captura('funcion_comprobante_eliminado','text');
			$this->captura('id_tabla','varchar');
			$this->captura('campo_subsistema','text');
			$this->captura('campo_descripcion','text');
			$this->captura('funcion_comprobante_validado','text');
			$this->captura('campo_fecha','text');
			$this->captura('estado_reg','varchar');
			$this->captura('campo_acreedor','text');
			$this->captura('campo_depto','text');
			$this->captura('momento_presupuestario','varchar');
			$this->captura('campo_fk_comprobante','text');
			$this->captura('tabla_origen','varchar');
			$this->captura('clase_comprobante','varchar');
			$this->captura('campo_moneda','text');
			$this->captura('id_usuario_reg','int4');
			$this->captura('fecha_reg','timestamp');
			$this->captura('id_usuario_mod','int4');
			$this->captura('fecha_mod','timestamp');
			$this->captura('usr_reg','varchar');
			$this->captura('usr_mod','varchar');
			$this->captura('campo_gestion_relacion','varchar');
			$this->captura('otros_campos','varchar');
			$this->captura('momento_comprometido','varchar');
	        $this->captura('momento_ejecutado','varchar');
	        $this->captura('momento_pagado','varchar');
			$this->captura('campo_id_cuenta_bancaria','varchar');
			$this->captura('campo_id_cuenta_bancaria_mov','varchar');
			$this->captura('campo_nro_cheque','varchar');
			$this->captura('campo_nro_cuenta_bancaria_trans','varchar');
			$this->captura('campo_nro_tramite','varchar');
			$this->captura('campo_tipo_cambio','varchar');
			$this->captura('campo_depto_libro','text');
			$this->captura('campo_fecha_costo_ini','text');
			$this->captura('campo_fecha_costo_fin','text');
			$this->captura('funcion_comprobante_editado','text');
		
		$this->armarConsulta();	
		
        $this->ejecutarConsulta(); 
		 		
		////////////////////////////
		
		
		if($this->respuesta->getTipo() == 'ERROR'){
			return $this->respuesta;
		}
		else {
		    $this->procedimiento = 'conta.ft_plantilla_comprobante_sel';
			$this->transaccion = 'CONTA_EXPPCD_SEL';
			$this->tipo_procedimiento = 'SEL';
			$this->setCount(false);
			$this->resetCaptura();
			$this->addConsulta();		
			
			$this->captura('tipo_reg','varchar');
			$this->captura('id_detalle_plantilla_comprobante','int4');
			$this->captura('id_plantilla_comprobante','int4');
			$this->captura('debe_haber','varchar');
			$this->captura('agrupar','varchar');
			$this->captura('es_relacion_contable','varchar');
			$this->captura('tabla_detalle','varchar');
			$this->captura('campo_partida','text');
			$this->captura('campo_concepto_transaccion','text');
			$this->captura('tipo_relacion_contable','varchar');
			$this->captura('campo_cuenta','text');
			$this->captura('campo_monto','text');
			$this->captura('campo_relacion_contable','text');
			$this->captura('campo_documento','text');
			$this->captura('aplicar_documento','varchar');
			$this->captura('campo_centro_costo','text');
			$this->captura('campo_auxiliar','text');
			$this->captura('campo_fecha','text');
			$this->captura('estado_reg','varchar');
			$this->captura('fecha_reg','timestamp');
			$this->captura('id_usuario_reg','int4');
			$this->captura('fecha_mod','timestamp');
			$this->captura('id_usuario_mod','int4');
			$this->captura('usr_reg','varchar');
			$this->captura('usr_mod','varchar');			
			$this->captura('primaria','varchar');
			$this->captura('otros_campos','varchar');
			$this->captura('nom_fk_tabla_maestro','varchar');
			$this->captura('campo_partida_ejecucion','text');
			$this->captura('descripcion','varchar');
			$this->captura('campo_monto_pres','varchar');
			$this->captura('id_detalle_plantilla_fk','integer');
			$this->captura('forma_calculo_monto','varchar');
			$this->captura('func_act_transaccion','varchar');
			$this->captura('campo_id_tabla_detalle','varchar');
			$this->captura('rel_dev_pago','varchar');
			$this->captura('campo_trasaccion_dev','TEXT');
			$this->captura('descripcion_base','varchar');
			$this->captura('campo_id_cuenta_bancaria','varchar');
			$this->captura('campo_id_cuenta_bancaria_mov','varchar');
			$this->captura('campo_nro_cheque','varchar');			
			$this->captura('campo_nro_cuenta_bancaria_trans','varchar');
			$this->captura('campo_porc_monto_excento_var','varchar');
			$this->captura('campo_nombre_cheque_trans','varchar');		
			$this->captura('prioridad_documento','integer');
			$this->captura('campo_orden_trabajo','varchar');
			$this->captura('campo_forma_pago','varchar');
			$this->captura('codigo_plantilla','varchar');
		    $this->captura('codigo','varchar');
			$this->captura('codigo_fk','varchar');
			
		
			
			$this->armarConsulta();
			$consulta=$this->getConsulta();			
	  
			$this->ejecutarConsulta($this->respuesta);
		}

		
       return $this->respuesta;		
	
	}	
			
}
?>