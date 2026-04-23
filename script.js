$(document).ready(function() {
        $(document).keyup(function(e) {
        if (e.keyCode === 27 || e.keyCode === 113) { 
            closeInventory();
        }
    });

   
    window.addEventListener('message', function(event) {
        let data = event.data;

        if (data.action === "display") {
            $("#inventory-container").fadeIn();
         
            setupSlots("#player-slots", data.playerItems, 40, true);
            setupSlots("#other-slots", data.otherItems, 40, false);
            
            updateWeight(data.currentWeight, 100);
            $("#other-title").text(data.otherTitle || "Yer / Araç");
        } else if (data.action === "hide") {
            closeInventory();
        }
    });
});


function setupSlots(containerId, items, slotCount, isPlayer) {
    let container = $(containerId);
    container.html(""); 
    for (let i = 1; i <= slotCount; i++) {
        
        let item = items ? items.find(x => x.slot == i) : null;
        let slotClass = (isPlayer && i <= 5) ? "slot hotbar" : "slot";
        
        let html = `
            <div class="${slotClass}" data-slot="${i}">
                ${item ? `
                    <div class="item" data-itemname="${item.name}" data-slot="${i}">
                        <img src="img/${item.name}.png" onerror="this.src='img/default.png'">
                        <div class="item-count">${item.count}</div>
                        <div class="item-name">${item.label || item.name}</div>
                    </div>
                ` : (isPlayer && i <= 5 ? `<div class="hotbar-number">${i}</div>` : "")}
            </div>`;
        container.append(html);
    }
    
    makeDraggable();
}


function makeDraggable() {
    $(".item").draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 9999,
        revert: 'invalid',
        start: function(event, ui) {
            $(this).css("opacity", "0.5");
        },
        stop: function(event, ui) {
            $(this).css("opacity", "1.0");
        }
    });

    $(".slot").droppable({
        accept: ".item",
        hoverClass: "slot-hover",
        drop: function(event, ui) {
            let fromSlot = ui.draggable.data("slot");
            let toSlot = $(this).data("slot");
            let fromInv = ui.draggable.closest('.slots').attr('id');
            let toInv = $(this
