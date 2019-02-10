<?php
/**
 *@package pXP
 *@file cabeceraDetallephp
 *@author  (admin)
 *@date 29-08-2013 00:28:30
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 *
HISTORIAL DE MODIFICACIONES:
ISSUE        FORK			FECHA:		      AUTOR                 DESCRIPCION
#33     ETR     	10/02/2019		  Miguel Mamani	  		Mostrar moneda $us en reporte comprobante
 */
?>
<font size="8"><table width="100%" cellpadding="1px"  rules="cols" border="1">
<tr>
			<td width="<?php  echo $this->with_col; ?>" align="right"><b><?php  echo $titulo; ?>&nbsp;&nbsp;&nbsp;&nbsp;</b></td>	
		<?php
                //#33
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
              <td width="11%" align="right"><b>&nbsp;</b></td>
              <td width="11%" align="right" ><span><b><?php  if ($this->tot_debe>0) { echo number_format($this->tot_debe, 2, '.', ',');} ?></b></span></td>
              <td width="11%" align="right" ><span><b><?php  if ($this->tot_haber>0) {echo number_format($this->tot_haber, 2, '.', ',');} ?></b></span></td>
              <td width="11%" align="right" ><span><b><?php  if ($this->tot_debe_mt>0) {echo number_format($this->tot_debe_mt, 2, '.', ',');} ?></b></span></td>
              <td width="11%" align="right" ><span><b><?php  if ($this->tot_haber_mt>0) {echo number_format($this->tot_haber_mt, 2, '.', ',');} ?></b></span></td>
		<?php	
		  }
		 else{  
		?>
		    <td width="11%" align="right"><b>&nbsp;</b></td>
			<td width="11%" align="right" ><span><b><?php  if ($this->tot_debe>0) { echo number_format($this->tot_debe, 2, '.', ',');} ?></b></span></td>
			<td width="11%" align="right" ><span><b><?php  if ($this->tot_haber>0) {echo number_format($this->tot_haber, 2, '.', ',');} ?></b></span></td>
			<td width="11%" align="right" ><span><b><?php  if ($this->tot_debe_mb>0) {echo number_format($this->tot_debe_mb, 2, '.', ',');} ?></b></span></td>
			<td width="11%" align="right" ><span><b><?php  if ($this->tot_haber_mb>0) {echo number_format($this->tot_haber_mb, 2, '.', ',');} ?></b></span></td>
		
		<?php } ?>
	    </tr>
</table></font>