//
//  ContentView.swift
//  Joystick
//
//  Created by TSOA2 on 1/18/24.
//

import SwiftUI

let display_width = UIScreen.main.bounds.size.width
let display_height = UIScreen.main.bounds.size.height

let light_yellow = Color(red: 247/255, green: 241/255, blue: 171/255)
let dark_yellow = Color(red: 240/255, green: 228/255, blue: 102/255)

let title_gradient = LinearGradient(
    colors: [
        light_yellow,
        dark_yellow
    ],
    startPoint: .leading,
    endPoint: .trailing
)
let joystick_color = dark_yellow
let joystick_pad_color = Color.white

let background_gradient = LinearGradient(
    colors: [Color.red, Color.orange, Color.yellow],
    startPoint: .top,
    endPoint: .bottom
)

let joystick_diameter : CGFloat = 150.0


struct ContentView: View {
    @State var default_circle_position : CGPoint = CGPoint(
        x: display_width / 2,
        y: display_height / -2.6
    )
    @State var circle_position: CGPoint = CGPoint(
        x: display_width / 2,
        y: display_height / -2.6
    )

    @State var ip_address : String = String()
    @State var return_val : Int32 = 0

    @State private var orientation = UIDeviceOrientation.unknown

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                let delta_x = value.translation.width
                let delta_y = value.translation.height
                
                let joystick_radius = joystick_diameter / 2
                let max_distance = display_width / 2 - joystick_radius
                let angle = atan2(delta_y, delta_x)
                let distance = sqrt(pow(delta_x, 2) + pow(delta_y, 2))
                
                circle_position = CGPoint(x: default_circle_position.x + delta_x, y: default_circle_position.y + delta_y)
                if distance > max_distance {
                    circle_position.x = default_circle_position.x + cos(angle) * max_distance
                    circle_position.y = default_circle_position.y + sin(angle) * max_distance
                }
                
                if return_val == 0 {
                    let final_x_data = (circle_position.x - default_circle_position.x) / (display_width - joystick_diameter) * 2;
                    let final_y_data = (circle_position.y - default_circle_position.y) / (display_width - joystick_diameter) * 2;
                    send_data(
                        final_x_data,
                        final_y_data * -1 // We need to reverse the y direction because of the weird iOS coordinate system :(
                    );
                }
            }
            .onEnded { value in
                circle_position = default_circle_position
                if return_val == 0 {
                    send_data(0.0, 0.0)
                }
            }
    }

    var body: some View {
        ZStack {
            background_gradient
                .ignoresSafeArea(.all)
                .frame(width: display_width, height: display_height)

            VStack {
                Text("JoyStick")
                    .bold()
                    .foregroundStyle(title_gradient)
                    .font(.custom("Helvetica Neue", size: 60))
                    .padding()
                Text("IP Address: ")
                    .bold()
                    .foregroundStyle(dark_yellow)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("Helvetica Neue", size: 25))
                    .padding(.leading, 50)
                
                TextField("127.0.0.1", text: $ip_address)
                    .bold()
                    .foregroundStyle(dark_yellow)
                    .font(.custom("Courier New", size: 15))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onSubmit {
                        let data : UnsafePointer<CChar> = NSString(string: ip_address).utf8String!
                        return_val = init_socket(data)
                    }
                    .padding(.leading, 50)
                Spacer()
                    .frame(height: (0.70 * display_height))
            }
        }


        Circle()
            .foregroundStyle(joystick_color)
            .frame(width: joystick_diameter, height: joystick_diameter)
            .position(circle_position)
            .gesture(drag)
    }
}

#Preview {
    ContentView()
}
