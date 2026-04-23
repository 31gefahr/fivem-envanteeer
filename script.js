let inventory = [];
$(document).ready(function() {
  
    $(document).keyup(function(e) {
        if (e.keyCode === 27) { 
            $.post(`https://${GetParentResourceName()}/closeInv`);
            $("#inventory-container").fadeOut();
        }
    });

   
    window.addEventListener('message', function(event) {
        let item = event.data;

        if (item.action === "display") {
            $("#inventory-container").fadeIn();
            setupInventory(item.playerItems, item.otherItems);
            updateWeight(item.currentWeight, 100);
            $("#other-title").text(item.otherTitle || "Yer / Araç");
        } else if (item.action === "hide") {
            $("#inventory-container").fadeOut();
        }
    });
});

function setupInventory(playerItems, otherItems) {
    
    $(".slot").html(""); 

  
    playerItems.forEach(item => {
      playerItems.forEach(item => {
    
    let slotElement = $(`#player-slots [data-slot="${item.slot}"]`);
    if (slotElement.length > 0) {
        slotElement.html(`
            <div class="item" data-itemname="${item.name}">
                <img src="img/${item.name}.png" onerror="this.src='img/default.png'">
                <div class="item-count">${item.count}</div>
            </div>
        `);
    }
});
        let slotElement = $(`#player-slots .slot[data-slot="${item.slot}"]`);
        slotElement.html(`
            <div class="item" draggable="true" data-itemname="${item.name}">
                <img src="img/${item.name}.png">
                <div class="item-count">${item.count}</div>
                <div class="item-name">${item.label}</div>
            </div>
        `);
    });

    
    if (otherItems) {
        otherItems.forEach(item => {
            let slotElement = $(`#other-slots .slot[data-slot="${item.slot}"]`);
            slotElement.html(`
                <div class="item" draggable="true" data-itemname="${item.name}">
                    <img src="img/${item.name}.png">
                    <div class="item-count">${item.count}</div>
                </div>
            `);
        });
    }

    
    makeDraggable();
}

function updateWeight(current, max) {
    let percent = (current / max) * 100;
    $("#weight-fill").css("width", percent + "%");
    $("#weight-text").text(current + " / " + max + " kg");
}

function makeDraggable() {
    $(".item").draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 9999,
        revert: 'invalid'
    });

    $(".slot").droppable({
        accept: ".item",
        drop: function(event, ui) {
            let fromSlot = ui.draggable.parent().data("slot");
            let toSlot = $(this).data("slot");
            let fromInv = ui.draggable.closest('.slots').attr('id');
            let toInv = $(this).closest('.slots').attr('id');

            $.post(`https://${GetParentResourceName()}/moveItem`, JSON.stringify({
                fromSlot: fromSlot,
                toSlot: toSlot,
                fromInv: fromInv,
                toInv: toInv
            }));
        }
    });
}
window.addEventListener('message', function(event) {
    if (event.data.action == "display") {
        $("#inventory-main").fadeIn();
        setupSlots(event.data.items);
        updateWeight(event.data.currentWeight);
    }
});

function setupSlots(items) {
    $(".slots-container").html("");
    for (let i = 1; i <= 50; i++) {
        let item = items.find(x => x.slot == i);
        let slotClass = i <= 5 ? "slot hotbar" : "slot";
        let html = `
            <div class="${slotClass}" data-slot="${i}" ondrop="drop(event)" ondragover="allowDrop(event)">
                ${item ? `<img src="img/${item.name}.png" class="item-image" draggable="true" ondragstart="drag(event)" data-slot="${i}">` : ""}
                <span class="item-count">${item ? item.count : ""}</span>
            </div>`;
        $(".slots-container").append(html);
    }
}

function drag(ev) { ev.dataTransfer.setData("fromSlot", ev.target.dataset.slot); }
function allowDrop(ev) { ev.preventDefault(); }

function drop(ev) {
    ev.preventDefault();
    let from = ev.dataTransfer.getData("fromSlot");
    let to = ev.target.closest(".slot").dataset.slot;

    
    $.post(`https://${GetParentResourceName()}/moveItem`, JSON.stringify({ from: from, to: to }));
}


$(document).keyup(function(e) {
    if (e.key === "Escape" || e.keyCode === 113) { 
        $.post(`https://${GetParentResourceName()}/closeInv`);
        $("#inventory-main").fadeOut();
    }
});
