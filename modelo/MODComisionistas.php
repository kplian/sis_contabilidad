<?php
/**
*@package pXP
*@file gen-MODComisionistas.php
*@author  (admin)
*@date 31-05-2017 20:17:02
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODComisionistas extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarComisionistas(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_comisionistas_sel';
		$this->transaccion='CONTA_CMS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_comisionista','int4');
		$this->captura('capacidad_envace','varchar');
		$this->captura('nit','varchar');
		$this->captura('codigo','varchar');
		$this->captura('cantidad_producto_entregado','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('porcentaje','numeric');
		$this->captura('descripcion','varchar');
		$this->captura('documento_entrega','varchar');
		$this->captura('monto_total','numeric');
		$this->captura('nro_documento','int4');
		$this->captura('razon_social','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('fecha_ini','date');
		$this->captura('precio_unitario','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('nro_contrato','varchar');
        $this->captura('revisado','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarComisionistas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_comisionistas_ime';
		$this->transaccion='CONTA_CMS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('capacidad_envace','capacidad_envace','varchar');
		$this->setParametro('nit','nit','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('cantidad_producto_entregado','cantidad_producto_entregado','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('porcentaje','porcentaje','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('documento_entrega','documento_entrega','varchar');
		$this->setParametro('monto_total','monto_total','numeric');
		$this->setParametro('nro_documento','nro_documento','int4');
		$this->setParametro('razon_social','razon_social','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('nro_contrato','nro_contrato','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarComisionistas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_comisionistas_ime';
		$this->transaccion='CONTA_CMS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_comisionista','id_comisionista','int4');
		$this->setParametro('capacidad_envace','capacidad_envace','varchar');
		$this->setParametro('nit','nit','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('cantidad_producto_entregado','cantidad_producto_entregado','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('porcentaje','porcentaje','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('documento_entrega','documento_entrega','varchar');
		$this->setParametro('monto_total','monto_total','numeric');
		$this->setParametro('nro_documento','nro_documento','int4');
		$this->setParametro('razon_social','razon_social','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('nro_contrato','nro_contrato','varchar');
		$this->setParametro('revisado','revisado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarComisionistas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_comisionistas_ime';
		$this->transaccion='CONTA_CMS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_comisionista','id_comisionista','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function cambiarRevision(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_comisionistas_ime';
        $this->transaccion='CONTA_REV_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_comisionista','id_comisionista','int8');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>