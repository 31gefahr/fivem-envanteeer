let inventory = [];

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
