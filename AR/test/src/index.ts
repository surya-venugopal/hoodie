import { initializeApp } from "firebase/app";
import { getFirestore, doc, getDoc, addDoc, collection, GeoPoint } from 'firebase/firestore';
import { getStorage, ref, uploadBytes, getDownloadURL } from "firebase/storage";

const app = initializeApp({
    apiKey: "AIzaSyBEm43RKIQ0EBF1jn_gE32zANSZPzIKSAE",
    authDomain: "hoodie-bc4c2.firebaseapp.com",
    databaseURL: "https://hoodie-bc4c2-default-rtdb.firebaseio.com",
    projectId: "hoodie-bc4c2",
    storageBucket: "hoodie-bc4c2.appspot.com",
    messagingSenderId: "330201716515",
    appId: "1:330201716515:web:dc6309003ce146cb925e96",
    measurementId: "G-6GQ9YVQBLZ"
});

import { PoseEngine } from "@geenee/bodyprocessors";
import { Recorder } from "@geenee/armature";
import { OutfitParams } from "@geenee/bodyrenderers-three";
import { AvatarRenderer } from "./avatarrenderer";


import "./index.css";

const db = getFirestore();
const storage = getStorage();

// Engine
const engine = new PoseEngine();
const token = location.hostname === "localhost" ?
    "zI3f8uGm_GW9tYlt3HBRs6vd400ExiGq" : "gRWk2CchTeglbUjxHjZ8kdJtHWI2Me9b";

// Parameters
const urlParams = new URLSearchParams(window.location.search);
let rear = urlParams.has("rear");

var skinModel = {
    file: "",
    avatar: false,
    outfit: {
        occluders: [/Head$/, /Body/],
        hidden: [/Eye/, /Teeth/, /Footwear/, /Glasses/]
    }
}

// Create spinner element
function createSpinner() {
    const container = document.createElement("div");
    container.className = "spinner-container";
    container.id = "spinner";
    const spinner = document.createElement("div");
    spinner.className = "spinner";
    for (let i = 0; i < 6; i++) {
        const dot = document.createElement("div");
        dot.className = "spinner-dot";
        spinner.appendChild(dot);
    }
    container.appendChild(spinner);
    return container;
}

var uid: string;
var video: Blob | undefined;
var position: GeolocationPosition;
var canUpload: boolean = true;
async function main() {

    const code = urlParams.get("code");
    if (code != null) {
        var fdocument = await getDoc(doc(db, "hoodies/" + code));
        if (fdocument.exists()) {
            uid = fdocument.data()["uid"];
            if (uid !== "") {
                fdocument = await getDoc(doc(db, "users/" + uid));
                if (fdocument.exists()) {
                    var avatar = fdocument.data()["avatar"];
                    var name = fdocument.data()["name"];
                    var currentSkin = fdocument.data()["currentSkin"];
                    if (currentSkin !== "") {
                        fdocument = await getDoc(doc(db, "skins/" + currentSkin));
                        if (fdocument.exists()) {
                            if (navigator.geolocation) {
                                navigator.geolocation.getCurrentPosition(successCallback, errorCallback);
                            } else {
                                console.log("Geolocation is not supported by this browser.");
                            }

                            console.log("All set");
                            skinModel.file = fdocument.data()["modelUrl"];

                            // Setup profile
                            const profilePic = document.getElementById('profilePic') as HTMLImageElement | null;
                            const profileName = document.getElementById('profileName') as HTMLDivElement | null;
                            if (!profilePic || !profileName)
                                return;
                            profilePic.src = "avatars/avatar" + avatar + ".png";
                            profileName.innerHTML = name;


                            // Send Comments
                            const button = document.getElementById('sendComment');
                            const input = document.querySelector('input');
                            if (!button || !input)
                                return;
                            button.addEventListener('click', () => {
                                const message = input.value;

                                input.value = ''; // clear the input field
                            });

                            // Renderer
                            const container = document.getElementById("root");
                            if (!container)
                                return;

                            // Sign up
                            const signup = document.getElementById("signup") as HTMLButtonElement | null;
                            if (signup) {
                                signup.onclick = () => {
                                    window.open("https://hoodie-bc4c2.web.app");
                                }
                            }

                            const renderer = new AvatarRenderer(
                                container, "crop", !rear, skinModel.file,
                                skinModel.avatar ? undefined : skinModel.outfit);

                            // Camera switch
                            const cameraSwitch = document.getElementById(
                                "camera-switch") as HTMLButtonElement | null;
                            if (cameraSwitch) {
                                cameraSwitch.onclick = async () => {
                                    cameraSwitch.disabled = true;
                                    rear = !rear;
                                    await engine.setup({ size: { width: 1920, height: 1080 }, rear });
                                    await engine.start();
                                    renderer.setMirror(!rear);
                                    cameraSwitch.disabled = false;
                                }
                            }

                            // Recorder
                            const safari = navigator.userAgent.indexOf('Safari') > -1 &&
                                navigator.userAgent.indexOf('Chrome') <= -1
                            const ext = safari ? "mp4" : "webm";
                            const recorder = new Recorder(renderer, "video/" + ext);
                            const recordButton = document.getElementById(
                                "record") as HTMLButtonElement | null;
                            if (recordButton)
                                recordButton.onclick = () => {
                                    const spinner = createSpinner();
                                    document.body.appendChild(spinner);
                                    recorder?.start();
                                    setTimeout(async () => {
                                        video = await recorder?.stop();
                                        if (!video)
                                            return;

                                        var currentdate = new Date();
                                        const storageRef = ref(storage, 'spotted/' + uid + '/' + currentdate.toString() + '.mp4');
                                        if (!video)
                                            return
                                        if (canUpload) {
                                            uploadBytes(storageRef, video).then(async (snapshot) => {
                                                console.log('Uploaded a blob!');

                                                var url = await getDownloadURL(ref(storage, snapshot.ref.toString()));
                                                await addDoc(collection(db, "spotted"), {
                                                    uid: uid,
                                                    time: currentdate,
                                                    videoUrl: url,
                                                    location: new GeoPoint(position.coords.latitude, position.coords.longitude)
                                                });
                                            });
                                        }
                                        document.body.removeChild(spinner);

                                        // const url = URL.createObjectURL(video);
                                        // console.log(url);

                                        // const link = document.createElement("a");
                                        // link.hidden = true;
                                        // link.href = url;
                                        // link.download = "capture." + ext;
                                        // link.click();
                                        // link.remove();
                                        // URL.revokeObjectURL(url);
                                    }, 5000);
                                };

                            // Initialization
                            await Promise.all([
                                engine.addRenderer(renderer),
                                engine.init({ token: token })
                            ]);
                            await engine.setup({ size: { width: 1920, height: 1080 }, rear });
                            await engine.start();
                            // document.getElementById("dots")?.remove();

                        } else { }
                    } else { 
                        console.log("No skin attached");
                    }
                } else {

                }
            }
            else {
                console.log("Hoodie not connected");
            }
        } else {
            console.log("Code does not exist");
        }
    } else {
        console.log("Code not entered");
    }
}

function successCallback(pos: GeolocationPosition) {
    position = pos;
};

function errorCallback(error: any) {
    canUpload = false;
};


main();
