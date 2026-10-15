
%dw 2.0
output application/json
var body = payload
var status = upper(trim(body.statusCode default ""))
---
{
    received: true,
    carrierCode: upper(attributes.uriParams.carrierCode),
    carrierEventId: attributes.headers.'x-carrier-event-id' default "",
    trackingNumber: body.awbNumber default "",
	shipmentId: body.referenceNumber default "",    rawStatusCode: body.statusCode default "",
    normalisedMilestone:
        if (status == "PU") "PICKED_UP"
        else if (status == "IT") "IN_TRANSIT"
        else if (status == "OOD") "OUT_FOR_DELIVERY"
        else if (status == "DL") "DELIVERED"
        else if (status == "EX") "EXCEPTION"
        else if (status == "RTO") "RETURN_TO_ORIGIN"
        else "EXCEPTION",
    eventTimestamp: body.eventDateTime default null,
    location: {
        facilityCode: body.scanLocation.facilityCode default "",
        city: body.scanLocation.city default "",
        state: body.scanLocation.state default "",
        country: body.scanLocation.country default "",
        latitude: body.scanLocation.latitude default null,
        longitude: body.scanLocation.longitude default null
    },
    revisedEta: body.revisedEta default null,
    remarks: body.remarks default ""
}
