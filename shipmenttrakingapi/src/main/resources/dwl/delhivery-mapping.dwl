
%dw 2.0
output application/json
var body = payload
var status = upper(trim(body.shipment_status default ""))
---
{
    received: true,
    carrierCode: upper(attributes.uriParams.carrierCode),
    carrierEventId: attributes.headers.'x-carrier-event-id' default "",
    trackingNumber: body.waybill default "",
	shipmentId: body.referenceNumber default "",    rawStatusCode: body.shipment_status default "",
    normalisedMilestone:
        if (status == "MANIFESTED") "PICKED_UP"
        else if (status == "PICKED UP") "PICKED_UP"
        else if (status == "IN TRANSIT") "IN_TRANSIT"
        else if (status == "REACHED HUB") "ARRIVED_AT_HUB"
        else if (status == "OUT FOR DELIVERY") "OUT_FOR_DELIVERY"
        else if (status == "UNDELIVERED") "DELIVERY_ATTEMPTED"
        else if (status == "DELIVERED") "DELIVERED"
        else if (status == "EXCEPTION") "EXCEPTION"
        else if (status == "RTO") "RETURN_TO_ORIGIN"
        else "EXCEPTION",
    eventTimestamp: body.status_date default null,
    location: {
        city: body.location.city default "",
        state: body.location.state default "",
        country: body.location.country default "IN"
    },
    revisedEta: body.expected_delivery_date default null,
    remarks: body.status_description default ""
}
