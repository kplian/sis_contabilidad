<?php
/**
*@package pXP
*@file gen-MODIntRelDevengado.php
*@author  (admin)
*@date 09-10-2015 12:31:01
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODIntRelDevengado extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarIntRelDevengado(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_rel_devengado_sel';
		$this->transaccion='CONTA_RDE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_rel_devengado','int4');
		$this->captura('id_int_transaccion_pag','int4');
		$this->captura('id_int_transaccion_dev','int4');
		$this->captura('monto_pago','numeric');
		$this->captura('id_partida_ejecucion_pag','int4');
		$this->captura('monto_pago_mb','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		
		$this->captura('nro_cbte_dev','varchar');
		$this->captura('desc_cuenta_dev','TEXT');
		$this->captura('desc_partida_dev','TEXT');
		$this->captura('desc_centro_costo_dev','TEXT');
		$this->captura('desc_orden_dev','VARCHAR');
		$this->captura('importe_debe_dev','NUMERIC');
		$this->captura('importe_haber_dev','NUMERIC');
		
		$this->captura('desc_cuenta_pag','TEXT');
		$this->captura('desc_partida_pag','TEXT');
		$this->captura('desc_centro_costo_pag','TEXT');
		$this->captura('desc_orden_pag','VARCHAR');
		$this->captura('importe_debe_pag','NUMERIC');
		$this->captura('importe_haber_pag','NUMERIC');
		
		$this->captura('id_cuenta_dev','INTEGER');
		$this->captura('id_orden_trabajo_dev','INTEGER');
		$this->captura('id_auxiliar_dev','INTEGER');
		$this->captura('id_centro_costo_dev','INTEGER');
		$this->captura('id_cuenta_pag','INTEGER');
		
		$this->captura('id_orden_trabajo_pag','INTEGER');
		$this->captura('id_auxiliar_pag','INTEGER');
		$this->captura('id_centro_costo_pag','INTEGER');
		$this->captura('id_int_comprobante_pago','int4');
		$this->captura('id_int_comprobante_dev','int4');
		
		$this->captura('tipo_partida_dev','varchar');
		$this->captura('tipo_partida_pag','varchar');
		
		$this->captura('desc_auxiliar_dev','text');
		$this->captura('desc_auxiliar_pag','text');
		
		$this->captura('importe_gasto_pag','NUMERIC');
        $this->captura('importe_recurso_pag','NUMERIC');
        $this->captura('importe_gasto_dev','NUMERIC');
        $this->captura('importe_recurso_de','NUMERIC');
		
		
		 
		
		
	
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarIntRelDevengado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_rel_devengado_ime';
		$this->transaccion='CONTA_RDE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_transaccion_pag','id_int_transaccion_pag','int4');
		$this->setParametro('id_int_transaccion_dev','id_int_transaccion_dev','int4');
		$this->setParametro('monto_pago','monto_pago','numeric');
		$this->setParametro('id_partida_ejecucion_pag','id_partida_ejecucion_pag','int4');
		$this->setParametro('monto_pago_mb','monto_pago_mb','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarIntRelDevengado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_rel_devengado_ime';
		$this->transaccion='CONTA_RDE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_rel_devengado','id_int_rel_devengado','int4');
		$this->setParametro('id_int_transaccion_pag','id_int_transaccion_pag','int4');
		$this->setParametro('id_int_transaccion_dev','id_int_transaccion_dev','int4');
		$this->setParametro('monto_pago','monto_pago','numeric');
		$this->setParametro('id_partida_ejecucion_pag','id_partida_ejecucion_pag','int4');
		$this->setParametro('monto_pago_mb','monto_pago_mb','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarIntRelDevengado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_rel_devengado_ime';
		$this->transaccion='CONTA_RDE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_rel_devengado','id_int_rel_devengado','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>