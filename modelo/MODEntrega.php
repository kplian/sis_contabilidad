<?php
/**
*@package pXP
*@file gen-MODEntrega.php
*@author  (admin)
*@date 17-11-2016 19:50:19
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODEntrega extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarEntrega(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_entrega_sel';
		$this->transaccion='CONTA_ENT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('pes_estado','pes_estado','varchar');
		//Definicion de la lista del resultado del query
		$this->captura('id_entrega','int4');
		$this->captura('fecha_c31','date');
		$this->captura('c31','varchar');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_depto_conta','int4');
		$this->captura('id_estado_wf','int4');
        $this->captura('id_proceso_wf','int4');
        $this->captura('nro_tramite','varchar');



		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarEntrega(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_ENT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('fecha_c31','fecha_c31','date');
		$this->setParametro('c31','c31','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarEntrega(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_ENT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entrega','id_entrega','int4');
		$this->setParametro('fecha_c31','fecha_c31','date');
		$this->setParametro('c31','c31','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarEntrega(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_ENT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entrega','id_entrega','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function crearEntrega(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_CRENT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobantes','id_int_comprobantes','varchar');
		$this->setParametro('total_cbte','total_cbte','int4');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');


        //$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
       // $this->setParametro('id_estado_wf','id_estado_wf','int4');
       // $this->setParametro('estado','estado','varchar');
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	 function cambiarEstado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_ime';
		$this->transaccion='CONTA_FINENTR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entrega','id_entrega','int4');
		$this->setParametro('c31','c31','varchar');
		$this->setParametro('fecha_c31','fecha_c31','date');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('id_tipo_relacion_comprobante','id_tipo_relacion_comprobante','int4');
         //$this->setParametro('estados','estados','varchar');
         
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function recuperarEntrega(){
		  //Definicion de variables para ejecucion del procedimientp
		  $this->procedimiento='conta.ft_entrega_sel';
		  $this->transaccion='CONTA_REPENT_SEL';
		  $this->tipo_procedimiento='SEL';//tipo de transaccion
		  $this->setCount(false);
		  
		  //captura parametros adicionales para el count
		  $this->setParametro('id_entrega','id_entrega','int4');


		 
		
		//Definicion de la lista del resultado del query
		$this->captura('id_entrega','int4');
        $this->captura('estado','varchar');
        $this->captura('c31','varchar');
        $this->captura('id_depto_conta','int4');
        $this->captura('fecha_c31','date');
        $this->captura('codigo','varchar');
        $this->captura('nombre_partida','varchar');
        $this->captura('importe_debe_mb','numeric');
        $this->captura('importe_haber_mb','numeric');
        $this->captura('importe_debe_mb_completo','numeric');
        $this->captura('importe_haber_mb_completo','numeric');
        $this->captura('importe_gasto_mb','numeric');
        $this->captura('importe_recurso_mb','numeric');
        $this->captura('factor_reversion','numeric');
        $this->captura('codigo_cc','varchar');
        $this->captura('codigo_categoria','varchar');
        $this->captura('codigo_cg','varchar');
        $this->captura('nombre_cg','varchar');
        $this->captura('beneficiario','varchar');
        $this->captura('glosa1','varchar');
        $this->captura('id_int_comprobante','int4');
        $this->captura('id_int_comprobante_dev','int4');
        $this->captura('id_cuenta_bancaria','int4');
		
		
		
		  
		              
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	function ListarSiguienteEstado()
    {
        $this->procedimiento='conta.ft_entrega_ime';
        $this->transaccion='CONTA_SIG_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function ListarAnteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_entrega_ime';
        $this->transaccion='CONTA_ANT_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_solicitud','id_solicitud','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('operacion','operacion','varchar');

        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('obs','obs','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	
			
}
?>