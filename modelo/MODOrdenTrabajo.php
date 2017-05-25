<?php
/**
*@package pXP
*@file MODOrdenTrabajo.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 21:08:55
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODOrdenTrabajo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarOrdenTrabajo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.f_orden_trabajo_sel';
		$this->transaccion='CONTA_ODT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_orden_trabajo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_final','date');
		$this->captura('fecha_inicio','date');
		$this->captura('desc_orden','varchar');
		$this->captura('motivo_orden','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tipo','varchar');
		$this->captura('movimiento','varchar');
		$this->captura('codigo','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_orden_trabajo_fk','int4');
		
		

		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

function listarOrdenTrabajoAll(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.f_orden_trabajo_sel';
		$this->transaccion='CONTA_ODTALL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_orden_trabajo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_final','date');
		$this->captura('fecha_inicio','date');
		$this->captura('desc_orden','varchar');
		$this->captura('motivo_orden','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tipo','varchar');
		$this->captura('movimiento','varchar');
		$this->captura('codigo','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_orden_trabajo_fk','int4');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


   function listarOrdenTrabajoArb(){
		    //Definicion de variables para ejecucion del procedimientp
		    $this->procedimiento='conta.f_orden_trabajo_sel';
		    $this-> setCount(false);
		    $this->transaccion='CONTA_ODTARB_SEL';
		    $this->tipo_procedimiento='SEL';//tipo de transaccion
		    
		    $id_padre = $this->objParam->getParametro('id_padre');
		    
		    $this->setParametro('node','node','varchar'); 
			  
		            
		    //Definicion de la lista del resultado del query
		    $this->captura('id_orden_trabajo','int4');
			$this->captura('estado_reg','varchar');
			$this->captura('fecha_final','date');
			$this->captura('fecha_inicio','date');
			$this->captura('desc_orden','varchar');
			$this->captura('motivo_orden','varchar');
			$this->captura('fecha_reg','timestamp');
			$this->captura('id_usuario_reg','int4');
			$this->captura('id_usuario_mod','int4');
			$this->captura('fecha_mod','timestamp');
			$this->captura('usr_reg','varchar');
			$this->captura('usr_mod','varchar');
			$this->captura('tipo','varchar');
			$this->captura('movimiento','varchar');
			$this->captura('codigo','varchar');
			$this->captura('tipo_nodo','varchar');
			$this->captura('id_orden_trabajo_fk','int4');
			
			 
		     //Ejecuta la instruccion
		     $this->armarConsulta();
			 $this->ejecutarConsulta();
		    
		    return $this->respuesta;       
    }
			
	function insertarOrdenTrabajo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_orden_trabajo_ime';
		$this->transaccion='CONTA_ODT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_final','fecha_final','date');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('desc_orden','desc_orden','varchar');
		$this->setParametro('motivo_orden','motivo_orden','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('movimiento','movimiento','varchar');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarOrdenTrabajo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_orden_trabajo_ime';
		$this->transaccion='CONTA_ODT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_final','fecha_final','date');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('desc_orden','desc_orden','varchar');
		$this->setParametro('motivo_orden','motivo_orden','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('movimiento','movimiento','varchar');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarOrdenTrabajo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_orden_trabajo_ime';
		$this->transaccion='CONTA_ODT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	function insertarOrdenTrabajoArb(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_orden_trabajo_ime';
		$this->transaccion='CONTA_ODTARB_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_orden_trabajo_fk','id_orden_trabajo_fk','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_final','fecha_final','date');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('desc_orden','desc_orden','varchar');
		$this->setParametro('motivo_orden','motivo_orden','varchar');
		
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('movimiento','movimiento','varchar');
		$this->setParametro('codigo','codigo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarOrdenTrabajoArb(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_orden_trabajo_ime';
		$this->transaccion='CONTA_ODTARB_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_final','fecha_final','date');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('desc_orden','desc_orden','varchar');
		$this->setParametro('motivo_orden','motivo_orden','varchar');
		
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('movimiento','movimiento','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_orden_trabajo_fk','id_orden_trabajo_fk','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	
			
}
?>