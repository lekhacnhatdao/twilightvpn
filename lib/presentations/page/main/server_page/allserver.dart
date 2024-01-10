import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openvpn/domain/model/vpn/vpn_server_model.dart';
import 'package:openvpn/presentations/bloc/app_cubit.dart';
import 'package:openvpn/presentations/bloc/app_state.dart';

import 'package:openvpn/presentations/route/app_router.gr.dart';
import 'package:openvpn/presentations/widget/impl/app_label_text.dart';
import 'package:openvpn/resources/assets.gen.dart';

class AllServer extends StatefulWidget {
  const AllServer({super.key});

  @override
  State<AllServer> createState() => _AllServerState();
}

class _AllServerState extends State<AllServer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return Column(
        children: [
          const SizedBox(height: 24),
          // const AppLabelText(text: Strings.visualLocation),
          // const AppBodyText(
          //   text: Strings.visualLocationDes,
          //   color: AppColors.textSecondary,
          //   size: 10,
          // ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) {
                final server = state.servers[index];
                final isSelected = state.currentServer?.id == server.id;
                final free = state.servers[index].vip;
                return _buildItem(server, isSelected, state.isVip, free);
              },
              itemCount: state.servers.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildItem(
      VpnServerModel server, bool isSelected, bool isVip, bool free) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow:const [
             BoxShadow(
                color: Colors.grey, blurRadius: 1, offset: Offset(3, 3))
          ]),
      child: InkWell(
        onTap: isSelected
            ? null
            : () {
                _handleItemTapped(server, isVip);
              },
        child: Container(
          height: 40,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(blurRadius: 1, spreadRadius: 1, color: Colors.grey)
                ]),
                child: Image.asset(
                  server.flag,
                  height: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                server.country == 'Hong Kong'
                    ? server.country.toString()
                    : server.region.toString() +
                        '-' +
                        server.country.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              const Spacer(),
              if (isSelected)
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    return AppLabelText(
                      color: state.colorStatus,
                      size: 10,
                    );
                  },
                ),
              const Spacer(),
              free ? Assets.images.crown.image(height: 20) : const SizedBox(),
              server.vip && !isVip
                  ? const SizedBox()
                  : const SizedBox(
                      width: 10,
                    ),
              server.vip && !isVip
                  ? const SizedBox()
                  : isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xff18daa3),
                        )
                      : const Icon(
                          Icons.radio_button_unchecked,
                          color: Color(0xff18daa3),
                        )
            ],
          ),
        ),
      ),
    );
  }

  void _handleItemTapped(VpnServerModel server, bool isVip) {
    if (server.vip && !isVip) {
      AutoRouter.of(context).push(const PremiumRoute());
    } else {
      context.read<AppCubit>().autoConnect(server);
    }
  }
}
