<font size="8">
<table width="100%" cellpadding="5px"  rules="cols" border="1">
<tbody>	
		<tr>
			<td width="60%" ><b>Beneficiario:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['beneficiario']; ?></td>
			<?php  
			   if($this->cabecera[0]['c31'] !=''){ 
			?>
			  <td width="40%">
			  	<table width="100%" cellpadding="0px"  rules="cols" border="0">
			  	<tr><td width="100%"><b>Nro Trámite:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['nro_tramite']; ?></td></tr>
			    <tr><td width="100%"><b>Cbte Rel.:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['c31']; ?></td></tr>
			    </table>
			  </td>
			<?php
               } 
			   else{
			?>
			<td width="40%"><b>Nro Trámite:</b>&nbsp;&nbsp;&nbsp;&nbsp;  <?php  echo $this->cabecera[0]['nro_tramite']; ?></td>
			<?php
			    }
			?>
			
		</tr>
		
		<tr>
			<td><b>Glosa:</b>&nbsp;&nbsp;&nbsp;&nbsp; <?php  echo trim($this->cabecera[0]['glosa1']).'<BR/>'.trim($this->cabecera[0]['glosa2']); ?></td>
			 <?php 
			  if ($this->cabecera[0]['id_moneda'] != $this->cabecera[0]['id_moneda_base']){
			 ?>
		      <td>
		      	<b>T/C:</b> &nbsp;&nbsp;&nbsp;&nbsp;<?php  if($this->cabecera[0]['sw_tipo_cambio']=='no'){echo $this->cabecera[0]['tipo_cambio'];}else{echo 'Por detalle';} ?><br/>
			    <b>Dctos:</b><?php echo $this->cabecera[0]['documentos']; ?></td>
		    <?php
			 } else {
			 ?>
			    <td><b>Dctos: </b><?php echo $this->cabecera[0]['documentos']; ?></td>
			<?php
			}
			?>
		</tr>
</tbody>
</table></font>