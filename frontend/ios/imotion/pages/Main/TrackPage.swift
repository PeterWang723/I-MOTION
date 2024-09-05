//
//  TrackPage.swift
//  imotion
//
//  Created by Peter Wang on 2024/6/21.
//
import SwiftUI
import MapKit

struct TrackPage: View {
    @EnvironmentObject var appState:AppState
    @State var camera: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var selectedDate: Date = Date()
    @State var today: Date = Date()
    @StateObject var inferViewModel = InferViewModel()
    @State private var isLoading = true
    @State private var notReady = false
    @State private var scrollViewHeight: CGFloat = 200
    @State private var isDragging = false
    var body: some View {
        ZStack(alignment:.top) {
            if selectedDate.startOfDay == Date().startOfDay && today.startOfDay <= Date().startOfDay{
                Map(position: $camera){
                    UserAnnotation()
                }
                .mapControls{
                    MapUserLocationButton()
                }
                
            } else {
                Map{
                    ForEach(inferViewModel.polylines) { polyline in
                            MapPolyline(coordinates: polyline.points)
                                .stroke(inferViewModel.color(for: polyline.mode), lineWidth: 5)
                        
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    if isLoading {
                        VStack {
                            Capsule()
                                .foregroundColor(Color(.systemGray5))
                                .frame(width: 48, height: 6)
                                .padding(.top, 8)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            isDragging = true
                                            let newHeight = scrollViewHeight - value.translation.height
                                            scrollViewHeight = max(100, min(400, newHeight))
                                        }
                                        .onEnded { _ in
                                            isDragging = false
                                        }
                                )
                                .animation(.interactiveSpring(), value: isDragging)
                            if !notReady {
                                ProgressView()
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                    .frame(height: scrollViewHeight)
                            } else {
                                Text("Your Activity Data Is Still Not Ready")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: scrollViewHeight)
                            }
                        }
                        .background(Color.white)
                        .clipShape(TopCornersRoundedShape(radius: 10))
                        .shadow(radius: 5)
                    } else {
                        TripListView(selectedDate:$selectedDate, inferViewModel:inferViewModel)
                    }
                }
                .onAppear{
                    inferViewModel.privacy = appState.privacy
                    if today.startOfDay < Date().startOfDay {
                        today = Date()
                    }
                }
            }
            
            SettingButton(inferViewModel:inferViewModel, selectedDate:$selectedDate, isLoading:$isLoading, notReady:$notReady)
                .padding(.leading)


        }
    }

}
