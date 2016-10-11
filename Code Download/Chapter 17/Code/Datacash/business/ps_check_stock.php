<?php
class PsCheckStock implements IPipelineSection
{
  private $_mProcessor;

  public function Process($processor)
  {
    // Set processor reference
    $this->_mProcessor = $processor;

    // Audit
    $processor->CreateAudit('PsCheckStock started.', 20200);

    // Send mail to supplier
    $processor->MailSupplier('HatShop stock check.',
                             $this->GetMailBody());

    // Audit
    $processor->CreateAudit('Notification email sent to supplier.', 20202);

    // Update order status
    $processor->UpdateOrderStatus(3);

    // Audit
    $processor->CreateAudit('PsCheckStock finished.', 20201);
  }

  private function GetMailBody()
  {
    $body = 'The following goods have been ordered:';
    $body .= "\n\n";

    $body .= $this->_mProcessor->GetOrderAsString(false);
    $body .= "\n\n";

    $body .= 'Please check availability and confirm via ' .
             'http://www.hatshop.com/admin.php';
    $body .= "\n\n";

    $body .= 'Order reference number: ';
    $body .= $this->_mProcessor->mOrderInfo['order_id'];

    return $body;
  }
}
?>
