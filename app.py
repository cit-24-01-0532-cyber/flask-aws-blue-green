from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    # Delivery System එකට අදාළ Mock Data (පසුව Database එකකට සම්බන්ධ කළ හැක)
    stats = {
        "total_deliveries": 142,
        "pending_deliveries": 12,
        "active_drivers": 8,
        "revenue": "Rs. 45,200"
    }
    
    recent_orders = [
        {"id": "#DEL-9081", "customer": "Amal Perera", "location": "Colombo 07", "status": "In Transit", "status_color": "blue"},
        {"id": "#DEL-9082", "customer": "Nimal Silva", "location": "Kandy", "status": "Pending", "status_color": "amber"},
        {"id": "#DEL-9083", "customer": "Kamal Fernando", "location": "Galle", "status": "Delivered", "status_color": "emerald"},
        {"id": "#DEL-9084", "customer": "Sunil Jayasinghe", "location": "Negombo", "status": "In Transit", "status_color": "blue"}
    ]

    return render_template(
        'index.html', 
        version="1.0 - Blue Environment", 
        stats=stats, 
        orders=recent_orders
    )

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)